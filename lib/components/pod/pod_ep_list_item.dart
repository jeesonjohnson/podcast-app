import 'package:flutter/material.dart';
import '../../models/managers/database_helper.dart';
import '../../models/structures/podcast_episode.dart';
import 'dart:io';
import '../../models/managers/episode_bloc.dart';
import 'package:provider/provider.dart';
import '../../models/structures/constants.dart';
import '../../models/managers/podcat_media_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../models/structures/podcast.dart';

class PodcastEpListItem extends StatelessWidget {
  final double sheetItemHeight;
  final PodcastEpisode podcastEpisode;
  final Podcast overallPodcast;
  const PodcastEpListItem({this.sheetItemHeight, this.podcastEpisode,this.overallPodcast });

  @override
  Widget build(BuildContext context) {
    PodcastMediaManager podcastManager = new PodcastMediaManager();
    CurrentEpisodeManager episodeBloc =
        Provider.of<CurrentEpisodeManager>(context);
    return Column(
      children: <Widget>[
        ExpansionTile(
          leading: IconButton(
            icon: Icon(
              Icons.file_download,
              color: textColorGreen,
            ),
            onPressed: () async {
              await podcastManager.setPodcastEpisodeSource(
                  podEpisode: podcastEpisode);
              episodeBloc.currentEpisode = podcastEpisode;
              print("comeplted settings");
              print(episodeBloc.currentEpisode.toString());
              // episodeBloc.currentEpisode=podcastEpisode;
              // episodeBloc.testText="testing";
              // print("Completed");
            },
          ),
          title: Text(
            podcastEpisode.episodeTitle,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 12,
                color: unselectedTextColor,
                fontWeight: FontWeight.w600),
          ),
          trailing: Icon(Icons.arrow_drop_down, color: accentColorRed),
          children: <Widget>[
            Divider(
              color: buttonBackgroundColor,
              thickness: 1.5,
              indent: 20,
              endIndent: 20,
            ),
            podcastOptionsDisplay(podcastEpisode, podcastManager, episodeBloc),
            Divider(
              color: buttonBackgroundColor,
              thickness: 1.5,
              indent: 20,
              endIndent: 20,
            ),
            podcastDetailsDisplay(context),
          ],
        ),
        Divider(
          color: buttonBackgroundColor,
          thickness: 1.2,
        )
      ],
    );
  }

  Widget podcastDetailsDisplay(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 131,
                height: 111,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: podcastEpisode.episodeImageUrl,
                    placeholder: (context, url) => new Image.file(
                      File(podcastEpisode.episodeLocalImageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      podcastEpisode.episodeTitle,
                      style: Theme.of(context).textTheme.body2.copyWith(
                          fontSize: 14,
                          color: unselectedTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Duration : ",
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: accentColorRed,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                              text: "4:28:17h",
                              style: Theme.of(context).textTheme.body2.copyWith(
                                  fontSize: 12,
                                  color: unselectedTextColor,
                                  fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Explicit : ",
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: accentColorRed,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "${podcastEpisode.episodeExplicit == "true" ? "yes" : "no"}",
                              style: Theme.of(context).textTheme.body2.copyWith(
                                  fontSize: 12,
                                  color: unselectedTextColor,
                                  fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        text: "Release : ",
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: accentColorRed,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                        children: <TextSpan>[
                          TextSpan(
                              text: dateTimeToString(
                                  podcastEpisode.episodeReleaseDate),
                              style: Theme.of(context).textTheme.body2.copyWith(
                                  fontSize: 12,
                                  color: unselectedTextColor,
                                  fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),

                    // Text(
                    //   "Duration: ${podcastEpisode.episodeDuration}h",
                    //   style: Theme.of(context).textTheme.body2.copyWith(
                    //       fontSize: 12,
                    //       color: unselectedTextColor,
                    //       fontWeight: FontWeight.normal),
                    // )
                  ],
                ))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Description",
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 12),
            ),
            HtmlWidget(
              podcastEpisode.episodeDescription,
              textStyle: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
              onTapUrl: (url) => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    'onTapUrl',
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                  content: Text(
                    url,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget podcastOptionsDisplay(PodcastEpisode episode,
      PodcastMediaManager podcastManager, CurrentEpisodeManager episodeBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.play_circle_outline,
            color: unselectedTextColor,
          ),
          onPressed: () async {
            await podcastManager.setPodcastEpisodeSource(
                podEpisode: podcastEpisode);
            episodeBloc.currentEpisode = podcastEpisode;
            print("comeplted settings");
            print(episodeBloc.currentEpisode.toString());
          },
        ),
        VerticalDivider(
          color: Colors.red,
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: unselectedTextColor,
          ),
          onPressed: () async {
            //To Be done!!!
          },
        ),
        VerticalDivider(
          color: Colors.red,
        ),
        IconButton(
          icon: Icon(
            Icons.file_download,
            color: unselectedTextColor,
          ),
          onPressed: () async {
            //To Be done!!!
          },
        ),
      ],
    );
  }
}
