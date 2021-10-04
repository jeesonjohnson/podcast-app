import 'package:flutter/material.dart';
import '../../screens/podcast_details_screen.dart';
import '../../models/managers/podcat_media_player.dart';
import 'modal_music_player.dart';
import 'package:provider/provider.dart';
import '../../models/managers/database_helper.dart';
import '../../models/structures/podcast_episode.dart';
import 'package:media_player/ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/managers/episode_bloc.dart';
import 'dart:io';
import '../../models/structures/constants.dart';
import 'package:marquee/marquee.dart';
import '../../models/structures/podcast.dart';

class MusicControls extends StatefulWidget {
  final bool getPastEpisodes;
  MusicControls({this.getPastEpisodes = false});

  _MusicControlsState createState() => _MusicControlsState();
}

class _MusicControlsState extends State<MusicControls> {
  bool isLoading = true;
  PodcastEpisode lastPlayedEpisode;
  bool isPlaying = false;
  PodcastMediaManager mediaManager = PodcastMediaManager();

  void getPreviousPlayerReady(BuildContext context) async {
    DatabaseHelper db = DatabaseHelper();
    lastPlayedEpisode = await db.getLastPlayedEpisode();
    final CurrentEpisodeManager counterBloc =
        Provider.of<CurrentEpisodeManager>(context);

    print("starting${lastPlayedEpisode.toString()}");
    if (lastPlayedEpisode != null) {
      if (lastPlayedEpisode.episodeAduioUrl != null) {
        print(lastPlayedEpisode.toString());
        await mediaManager.setPodcastEpisodeSource(
          podEpisode: lastPlayedEpisode,
          autoPlay: false,
          currentEpisodeSeek: lastPlayedEpisode.currentEpisodeSeek,
        );
      }
    } else {
      lastPlayedEpisode = null;
    }

    counterBloc.currentEpisode = lastPlayedEpisode;
    print(
        "currentttttttttttttttttttttttttttttttttt data ${counterBloc.currentEpisode.toString()}");
    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkIfPlaying() async {
    isPlaying = await mediaManager.currentPlayState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && widget.getPastEpisodes) {
      getPreviousPlayerReady(context);
    } else {
      isLoading = false;
    }
    
    return
        // !isLoading && lastPlayedEpisode==null?SizedBox(width: 1,height: 1,):
        ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.only(right: 2),
        color: modalMusicPlayerColor,
        width: MediaQuery.of(context).size.width - 20,
        height: 70,
        child: InkWell(
          onTap: () async {
            DatabaseHelper db = DatabaseHelper();
            PodcastEpisode currentEpisode = db.getCurrentPodcastEpisode();
            if (currentEpisode != null) {
              showMusicPlayer(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                flex: 4,
                child: CurrentPodcastData(),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  child: isLoading
                      ? Container(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          padding: EdgeInsets.only(bottom: 14),
                          child: IconButton(
                            onPressed: () {
                              mediaManager.togglePlayerStatus();
                            },
                            icon: Icon(
                              Icons.play_circle_outline,
                              color: Theme.of(context).accentColor,
                              size: 47,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMusicPlayer(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builderContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: modalMusicPlayerColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(50),
                      topRight: const Radius.circular(50))),
              child: BottomMusicPlayer(),
            ),
          );
        });
  }
}

class CurrentPodcastData extends StatelessWidget {
  const CurrentPodcastData({Key key}) : super(key: key);

  Widget podcastImageWidget(
      BuildContext context, PodcastEpisode currentEpisode) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pushNamed(PodcastDetailsScreen.route,
            arguments: Podcast(itunesID: currentEpisode.itunesID));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(currentEpisode.episodeLocalImageUrl),
        ),
      ),
    );
  }

  Widget podcastDetailsWidget(PodcastEpisode currentEpisode,
      BuildContext context, PodcastMediaManager podcastMediaManager) {
    return Container(
      padding: EdgeInsets.only(top: 7, right: 3, left: 3, bottom: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: currentEpisode.episodeTitle.length < 24
                ? Text(
                    currentEpisode.episodeTitle,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 14),
                  )
                : Marquee(
                    velocity: 30,
                    text: currentEpisode.episodeTitle,
                    blankSpace: 30,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 14),
                  ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: currentEpisode.episodeAuthor.length < 37
                ? Text(
                    "   ${currentEpisode.episodeAuthor}",
                    style:
                        Theme.of(context).textTheme.body2.copyWith(fontSize: 8),
                  )
                : Marquee(
                    text: currentEpisode.episodeAuthor,
                    blankSpace: 150,
                    velocity: 30,
                    style:
                        Theme.of(context).textTheme.body2.copyWith(fontSize: 8),
                  ),
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: podcastCurrentLocation(podcastMediaManager, context))
        ],
      ),
    );
  }

  Widget podcastCurrentLocation(
      PodcastMediaManager podcastMediaManager, BuildContext context) {
    VideoProgressIndicator progress = VideoProgressIndicator(
      podcastMediaManager.getMediaPlayer(),
      allowScrubbing: false,
      colors: VideoProgressColors(playedColor: accentColorRed),
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4),
    );
    return Column(
      children: <Widget>[
        Flexible(flex: 1, child: progress),
        // Flexible(
        //   flex: 1,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       Text(
        //         progress.controller.valueNotifier.value.duration.inMilliseconds
        //             .toString(),
        //         style: Theme.of(context).textTheme.body2.copyWith(fontSize: 10),
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper db = DatabaseHelper();
    PodcastEpisode currentEpisode = db.getCurrentPodcastEpisode();
    PodcastMediaManager podcastMediaManager = new PodcastMediaManager();
    final CurrentEpisodeManager episodeBloc =
        Provider.of<CurrentEpisodeManager>(context);
    return currentEpisode == null
        ? Center(
            child: Container(
              child: Text(
                "Select a podcast",
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(fontSize: 12, color: Colors.grey),
              ),
            ),
          )
        : Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: podcastImageWidget(context, currentEpisode),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: podcastDetailsWidget(
                      currentEpisode, context, podcastMediaManager),
                )
              ],
            ),
          );

    // return currentEpisode == null
    //     ? Center(
    //         child: Container(
    //           child: Text(
    //             "Choose an episode",
    //             style: Theme.of(context).textTheme.body2,
    //           ),
    //         ),
    //       )
    //     : Container(
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Container(
    //               width: 60,
    //               height: 40,
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(4),
    //                 child: Image.file(
    //                   File(currentEpisode.episodeLocalImageUrl),
    //                 ),
    //               ),
    //             ),
    //             Text(currentEpisode.episodeTitle)
    //           ],
    //         ),
    //       );
  }
}
