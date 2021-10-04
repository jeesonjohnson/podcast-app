import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';
import 'package:media_player/ui.dart';
import 'package:http/http.dart' as http;
import 'package:podcast_app/models/structures/constants.dart';
import 'package:podcast_app/models/structures/podcast_episode.dart';
import 'package:podcast_app/screens/podcast_details_screen.dart';
import '../../models/managers/database_helper.dart';
import '../../models/managers/podcat_media_player.dart';
import '../../models/managers/episode_bloc.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class BottomMusicPlayer extends StatefulWidget {
  @override
  _BottomMusicPlayerState createState() => _BottomMusicPlayerState();
}

class _BottomMusicPlayerState extends State<BottomMusicPlayer> {
  PodcastMediaManager podcastMediaManager = new PodcastMediaManager();
  DatabaseHelper db = DatabaseHelper();
  bool isPlaying = false;

  void togglePlaying() async {
    await podcastMediaManager.togglePlayerStatus();
    isPlaying = await podcastMediaManager.currentPlayState();
    setState(() {});
    print("Is it palyinggggggggggggggggg${isPlaying}");
  }

  void checkIfPlaying() async {
    isPlaying = await podcastMediaManager.currentPlayState();
  }

  @override
  Widget build(BuildContext context) {
    PodcastEpisode currentEpisode = db.getCurrentPodcastEpisode();
    checkIfPlaying();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 380,
      child: Container(
        padding: EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Stack(children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: FileImage(
                    File(currentEpisode.episodeLocalImageUrl),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        buttonBackgroundColor.withOpacity(0.5),
                        Colors.black,
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: currentEpisode.episodeLocalImageUrl == null
                                ? Text("Error in getting podcastImage",
                                    style: Theme.of(context).textTheme.body2)
                                : Image.file(
                                    File(currentEpisode.episodeLocalImageUrl)),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(children: <Widget>[
                            // Flexible(flex: 1,fit: FlexFit.loose,child: Placeholder(),),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: currentEpisode.episodeTitle.length < 24
                                  ? Text(
                                      currentEpisode.episodeTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(
                                              fontSize: 20,
                                              color: textColorGreen
                                                  .withOpacity(0.8)),
                                    )
                                  : Marquee(
                                      velocity: 30,
                                      text: currentEpisode.episodeTitle,
                                      blankSpace: 30,
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(fontSize: 20),
                                    ),
                            ),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: VideoProgressIndicator(
                                  podcastMediaManager.getMediaPlayer(),
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                      playedColor: accentColorRed),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 45),
                                )),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 9),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.replay_30,
                                        color: unselectedTextColor,
                                        size: 40,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: IconButton(
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_outline,
                                        color: unselectedTextColor,
                                        size: 60,
                                      ),
                                      onPressed: togglePlaying,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 9),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.forward_30,
                                        color: unselectedTextColor,
                                        size: 40,
                                      ),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
