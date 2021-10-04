import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import '../../models/structures/podcast.dart';
import 'bloc/state_provider.dart';
import 'bloc/state_bloc.dart';
import '../../components/pod/pod_ep_list_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../components/music/bottom_music_controls.dart';
import '../../models/managers/episode_bloc.dart';
import 'package:provider/provider.dart';

Podcast podcast;
Color drawerBarColor = Colors.black;

class OverallPodScreen extends StatefulWidget {
  static const String route = "overall_pod_screen";
  final Podcast tempPodcast;
  OverallPodScreen({this.tempPodcast});

  @override
  _OverallPodScreenState createState() => _OverallPodScreenState();
}

class _OverallPodScreenState extends State<OverallPodScreen> {
  bool isLoading = true;

  @override
  void initState() {
    getPodcastData(widget.tempPodcast.itunesID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context)=>CurrentEpisodeManager(),
      child: Scaffold(
        persistentFooterButtons: <Widget>[
          MusicControls(
            getPastEpisodes: false,
          ),
        ],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);

              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 25),
              child:
                  Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 25),
              child: Icon(Icons.favorite_border),
            )
          ],
        ),
        body: isLoading
            ? loadingWidget()
            : ChangeNotifierProvider<CurrentEpisodeManager>.value(
                value: CurrentEpisodeManager(), child: LayoutStarts()),
      ),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Podcast Episodes are loading...")
          ],
        ),
      ),
    );
  }

  Future<String> getPodcastData(String itunesID) async {
    try {
      var result =
          await http.get("https://itunes.apple.com/lookup?id=$itunesID");
      Map<String, dynamic> podcastLink = json.decode(result.body);
      String podcastRssLink = podcastLink["results"][0]["feedUrl"];
      podcast = await Podcast.genearlPodcastGetter(
          podcastUrl: podcastRssLink, itunesID: itunesID);
    } catch (e) {
      print("Netowrk error is");
      print(e.toString());
      print("Failed getting network data");
      throw NetworkImageLoadException;
    }
    setState(() {
      isLoading = false;
    });
    print(
        "PODCAST AUDIOOOOOOOOOOOOO URL ${podcast.podcastEpisodes[0].episodeAduioUrl}");
    return "Complted";
  }
}

class LayoutStarts extends StatelessWidget {
  const LayoutStarts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PodcastDetailsAnimation(),
        CustomBottomSheet(),
      ],
    );
  }
}

class PodcastDetailsAnimation extends StatefulWidget {
  @override
  _PodcastDetailsAnimationState createState() =>
      _PodcastDetailsAnimationState();
}

class _PodcastDetailsAnimationState extends State<PodcastDetailsAnimation> {
  @override
  Widget build(BuildContext context) {
    return PodcastDetails();
  }
}

class PodcastDetails extends StatelessWidget {
  const PodcastDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30),
            child: _podcastTitle(context),
          ),
          Container(
            width: double.infinity,
            child: PodcastCarousel(),
          )
        ],
      ),
    );
  }

  Widget _podcastTitle(BuildContext context) {
    return Text(podcast.podcastTitle,
        style: Theme.of(context)
            .textTheme
            .body1
            .copyWith(fontWeight: FontWeight.w700));
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     RichText(
    //       text: TextSpan(
    //         style: TextStyle(color: Theme.of(context).textTheme.body2.color),
    //         children: [
    //           TextSpan(text: podcast.podcastTitle),
    //           TextSpan(text: "\n"),
    //           TextSpan(
    //             text: podcast.podcastAuthor,
    //             style: TextStyle(
    //               fontWeight: FontWeight.w700,
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //     SizedBox(height: 10,),

    //   ],
    // );
  }
}

class PodcastCarousel extends StatefulWidget {
  const PodcastCarousel({Key key}) : super(key: key);

  @override
  _PodcastCarouselState createState() => _PodcastCarouselState();
}

class _PodcastCarouselState extends State<PodcastCarousel> {
  Widget getPodcastData(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).textTheme.body2.color,
            ),
            children: [
              TextSpan(text: podcast.podcastTitle),
              TextSpan(text: "\n"),
              TextSpan(
                text: podcast.podcastAuthor,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget getPodcastImage(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        child: Image.file(
          File(podcast.localPodcastImageUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 12),
        child: Column(
          children: <Widget>[
            CarouselSlider(
              height: 250,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              items: [getPodcastImage(context), getPodcastData(context)],
            ),
          ],
        ));
  }
}

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  double sheetTop = 300;
  double minSheetTop = 37;

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: sheetTop,
      left: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded ? sheetTop = 300 : sheetTop = minSheetTop;
            isExpanded = !isExpanded;
          });
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  const SheetContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 500;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Color(0xFF141414),
        ),
        child: Column(
          children: <Widget>[
            drawerHandle(),
            podcastEpisodes(context, sheetItemHeight)
          ],
        ));
  }

  Widget podcastEpisodes(BuildContext context, double sheetItemHeight) {
    //print(podcast.podcastEpisodes.toString());
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: podcast.podcastEpisodes.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 5, left: 20),
                    child: Text(
                      "Episodes",
                      style: Theme.of(context).textTheme.body2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                  );
                }
                return PodcastEpListItem(
                    sheetItemHeight: sheetItemHeight,
                    podcastEpisode: podcast.podcastEpisodes[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget drawerHandle() {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        bottom: 8,
      ),
      height: 5,
      width: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.grey),
    );
  }
}
// class OverallPodScreen extends StatefulWidget {
//   static const String route = "overall_pod_screen";
//   final Podcast podcast;
//   OverallPodScreen({this.podcast});
//   @override
//   _OverallPodScreenState createState() => _OverallPodScreenState();
// }

// class _OverallPodScreenState extends State<OverallPodScreen>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   Podcast podcast;
//   bool isLoading = true;
//   Animation<double> _heightFactorAnimation;
//   double collapsedHeightFactor = 0.67;
//   double expandedHeightFactor = 0.4;
//   bool isAnimationCompleted = false;

//   @override
//   void initState() {
//     getPodcastData(widget.podcast.itunesID);
//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     _heightFactorAnimation =
//         Tween<double>(begin: collapsedHeightFactor, end: expandedHeightFactor)
//             .animate(_controller);

//     // _controller.addStatusListener((currentStatus) {
//     //   if (currentStatus == AnimationStatus.completed) {
//     //     isAnimationCompleted = true;
//     //   }
//     // });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   onBottomPartTap() {
//     setState(() {
//       if (isAnimationCompleted) {
//         _controller.reverse();
//       } else {
//         _controller.forward();
//       }
//       isAnimationCompleted = !isAnimationCompleted;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(0),
//         child: AppBar(
//           elevation: 0.0,
//           actions: <Widget>[],
//         ),
//       ),
//       body: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, widget) {
//           return getMainWidget();
//         },
//       ),
//     );
//   }

//   Widget getMainWidget() {
//     print(expandedHeightFactor);
//     return GestureDetector(
//       onPanUpdate: (details) {
//         print(details.delta.dy);

//         onBottomPartTap();
//       },
//       child: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           isLoading
//               ? FractionallySizedBox(
//                   alignment: Alignment.topCenter,
//                   child: CachedNetworkImage(
//                     imageUrl: widget.podcast.podcastImageUrl,
//                     fit: BoxFit.cover,
//                     colorBlendMode: BlendMode.hue,
//                     color: Colors.black12,
//                   ),
//                   heightFactor: _heightFactorAnimation.value,
//                 )
//               : FractionallySizedBox(
//                   alignment: Alignment.topCenter,
//                   child: Image.file(
//                     File(podcast.localPodcastImageUrl),
//                     fit: BoxFit.cover,
//                     colorBlendMode: BlendMode.hue,
//                     color: Colors.black12,
//                   ),
//                   heightFactor: _heightFactorAnimation.value,
//                 ),
//           GestureDetector(
//             onTap: () {
//               onBottomPartTap();
//             },
//             child: FractionallySizedBox(
//               alignment: Alignment.bottomCenter,
//               heightFactor: 1.04 - _heightFactorAnimation.value,
//               child: Container(
//                 padding: EdgeInsets.only(left: 30,top: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(40.0),
//                     topRight: Radius.circular(40.0),
//                   ),
//                 ),
//                 child: Text(widget.podcast.podcastTitle),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Future<String> getPodcastData(String itunesID) async {
//     try {
//       var result =
//           await http.get("https://itunes.apple.com/lookup?id=$itunesID");
//       Map<String, dynamic> podcastLink = json.decode(result.body);
//       String podcastRssLink = podcastLink["results"][0]["feedUrl"];
//       this.podcast = await Podcast.genearlPodcastGetter(
//           podcastUrl: podcastRssLink, itunesID: itunesID);
//     } catch (e) {
//       print("Netowrk error is");
//       print(e.toString());
//       print("Failed getting network data");
//       throw NetworkImageLoadException;
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
// }

// //OLDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD CODE
// // class OverallPodScreen extends StatefulWidget {
// //   static const String route = "overall_pod_screen";
// //   final Podcast podcast;
// //   OverallPodScreen({this.podcast});
// //   @override
// //   _OverallPodScreenState createState() => _OverallPodScreenState();
// // }

// // class _OverallPodScreenState extends State<OverallPodScreen> {
// //   Podcast podcast;
// //   bool isLoading = true;
// //   @override
// //   void initState() {
// //     super.initState();
// //     getPodcastData(widget.podcast.itunesID);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(
// //           title: Text("HI THERE"),
// //         ),
// //         body: Column(
// //           children: <Widget>[
// //             Container(
// //               child: Text(widget.podcast.podcastTitle),
// //             ),
// //             isLoading
// //                 ? CachedNetworkImage(imageUrl: widget.podcast.podcastImageUrl)
// //                 : Image.file(
// //                     File(podcast.localPodcastImageUrl),
// //                   ),
// //           ],
// //         ));
// //   }

// //   Future<String> getPodcastData(String itunesID) async {
// //     try {
// //       var result =
// //           await http.get("https://itunes.apple.com/lookup?id=$itunesID");
// //       Map<String, dynamic> podcastLink = json.decode(result.body);
// //       String podcastRssLink = podcastLink["results"][0]["feedUrl"];
// //       this.podcast = await Podcast.genearlPodcastGetter(
// //           podcastUrl: podcastRssLink, itunesID: itunesID);
// //     } catch (e) {
// //       print("Netowrk error is");
// //       print(e.toString());
// //       print("Failed getting network data");
// //       throw NetworkImageLoadException;
// //     }
// //     setState(() {
// //       isLoading = false;
// //     });
// //   }
// // }
