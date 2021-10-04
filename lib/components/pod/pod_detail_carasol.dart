import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:podcast_app/models/managers/database_helper.dart';
import 'package:podcast_app/models/structures/constants.dart';
import '../../models/structures/podcast.dart';
import 'dart:io';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class PodDetailsCarasol extends StatelessWidget {
  final Podcast podcast;
  PodDetailsCarasol(this.podcast);

  Widget mainPodcastDetailsScreen(BuildContext context) {
    podcast.podcastAuthor = podcast.podcastAuthor == null
        ? "Failed Getting podcat author"
        : podcast.podcastAuthor;
    return Container(
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Container(
              width: 400,
              height: 460,
              padding: EdgeInsets.only(top: 70, left: 8, right: 8, bottom: 8),
              child: Center(
                  widthFactor: 2,
                  heightFactor: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: podcast.localPodcastImageUrl == null
                        ? Text("Error in getting podcastImage",
                            style: Theme.of(context).textTheme.body2)
                        : Image.file(File(podcast.localPodcastImageUrl)),
                  )),
            ),
          ),
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Container(
              padding: EdgeInsets.only(top: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 200,
                          height: 33,
                          child: podcast.podcastTitle.length < 12
                              ? Text(
                                  podcast.podcastTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                )
                              : Marquee(
                                  velocity: 30,
                                  text: podcast.podcastTitle,
                                  blankSpace: 30,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                ),

                          // Text(
                          //   podcast.podcastTitle,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: Theme.of(context).textTheme.body1.copyWith(
                          //       fontSize: 15, fontWeight: FontWeight.w600),
                          // ),
                        ),
                        Container(
                          width: 600,
                          height: 15,
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            podcast.podcastAuthor,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(fontSize: 10),
                          ),
                        )
                      ],
                    )),
                    // child: Container(
                    //   padding: EdgeInsets.only(top: 20, right: 10),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: RichText(
                    //       text: TextSpan(
                    //         children: <TextSpan>[
                    //           TextSpan(
                    //             text: podcast.podcastTitle,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .body1
                    //                 .copyWith(
                    //                     fontSize: 13,
                    //                     fontWeight: FontWeight.w600),
                    //           ),
                    //           TextSpan(text: "\n"),
                    //           TextSpan(
                    //             text: placeHolder,
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .body2
                    //                 .copyWith(fontSize: 10),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          width: 200,
                          height: 30,
                          padding: EdgeInsets.only(right: 40, bottom: 3),
                          child: SubscribeButton(podcast)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          podDetailsModalSheet(context);
        },
        child: mainPodcastDetailsScreen(context),
      ),
      // child: CarouselSlider(
      //   viewportFraction: 1.0,
      //   enableInfiniteScroll: false,
      //   items: <Widget>[
      //     mainPodcastDetailsScreen(context),
      //     podcastExtraDetailsWidget(context),
      //   ],
      // ),
    );
  }

  void podDetailsModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.transparent,
            child: Container(
              child: podcastDetails(context),
              decoration: BoxDecoration(
                  color: modalMusicPlayerColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(30),
                      topRight: const Radius.circular(30))),
            ),
          );
        });
  }

  Widget podcastDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Column(
        children: <Widget>[
          Text(
            podcast.podcastTitle,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(13),
                          width: 121,
                          height: 111,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: new Image.file(
                              File(podcast.localPodcastImageUrl),
                              fit: BoxFit.fill,
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
                            RichText(
                              text: TextSpan(
                                text: "Author : ",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
                                        color: accentColorRed,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "${podcast.podcastAuthor}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                              fontSize: 12,
                                              color: unselectedTextColor,
                                              fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Number Of Episodes : ",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
                                        color: accentColorRed,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "${podcast.podcastEpisodes.length.toString()}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                              fontSize: 12,
                                              color: unselectedTextColor,
                                              fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Language : ",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(
                                        color: accentColorRed,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "${podcast.language}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                              fontSize: 12,
                                              color: unselectedTextColor,
                                              fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Description:",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 12),
                  ),
                  HtmlWidget(
                    podcast.description,
                    textStyle: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
                    onTapUrl: (url) => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          'onTapUrl',
                          style: Theme.of(context).textTheme.body2.copyWith(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                        content: Text(
                          url,
                          style: Theme.of(context).textTheme.body2.copyWith(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),

                  // Text(
                  //   podcast.description,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .body2
                  //       .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
                  // ),
                  RichText(
                    text: TextSpan(
                      text: "Copyright : \n\n",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(
                            text: "${podcast.copyright}",
                            style: Theme.of(context).textTheme.body2.copyWith(
                                fontSize: 12,
                                color: unselectedTextColor,
                                fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            height: 350,
          )
        ],
      ),
    );
  }
}

class SubscribeButton extends StatefulWidget {
  final Podcast podcast;
  SubscribeButton(this.podcast);

  _SubscribeButtonState createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  bool isLoading = true;
  bool isSubscribed = false;
  @override
  Widget build(BuildContext context) {
    checkIfPodcastSubscribed();
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () async {
          DatabaseHelper db = DatabaseHelper();
          await db.invertPodcastSubscription(widget.podcast.itunesID);
          setState(() {
            isSubscribed = !isSubscribed;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSubscribed ? textColorGreen : buttonBackgroundColor,
            border: Border.all(
              width: 2.0,
              color: isSubscribed ? Colors.redAccent : Colors.redAccent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          //color: isSubscribed ? Colors.red : Colors.red,
          child: Center(
            child: Text(
              isSubscribed ? "Unsubscribe" : "Subscribe",
              style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: 14,
                  color: isSubscribed ? Colors.black : unselectedTextColor),
            ),
          ),
        ),
      ),
    );
  }

  void checkIfPodcastSubscribed() async {
    DatabaseHelper db = DatabaseHelper();
    isSubscribed =
        await db.isPodcastSubsribed(widget.podcast.itunesID) == "true";
    setState(() {});
  }
}
