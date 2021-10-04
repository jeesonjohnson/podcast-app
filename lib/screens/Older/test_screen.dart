import 'package:flutter/material.dart';
import 'package:podcast_app/models/structures/constants.dart';
import 'package:podcast_app/screens/Older/overall_pod_description.dart';
import '../../models/structures/podcast.dart';
import 'package:provider/provider.dart';
import '../../models/managers/episode_bloc.dart';
import '../../components/music/bottom_music_controls.dart';
import '../../components/pod/pod_detail_carasol.dart';

Podcast podcast;
var top = 0.0;

class MainTestScreen extends StatelessWidget {
  static const String route = "pod_test_screen";
  MainTestScreen({@required Podcast currentpodcast}) {
    podcast = currentpodcast;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              top = constraints.biggest.height;
              return FlexibleSpaceBar(
                centerTitle: true,
                title: AnimatedOpacity(
                  duration: Duration(milliseconds: 100),
                  opacity: top == 80 ? 0.9 : 0.0,
                  //opacity: 1.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 250,
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      podcast.podcastTitle,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
                background: PodDetailsCarasol(podcast),
              );
            }),
          ),
        ];
      },
      body: ListView.builder(
        padding: EdgeInsets.all(14),
        itemCount: 100,
        itemBuilder: (context, index) {
          if (index <= 0) {
            return Divider(
          color: unselectedTextColor,
          thickness: 1.2,
        );
          }
          return Text("List Item: " + index.toString());
        },
      ),
    ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(
  //     builder: (context) => CurrentEpisodeManager(),
  //     child: Scaffold(
  //       persistentFooterButtons: <Widget>[
  //         MusicControls(
  //           getPastEpisodes: false,
  //         ),
  //       ],
  //       body: CustomScrollView(
  //         slivers: <Widget>[
  //           SliverAppBar(
  //             expandedHeight: 150,
  //             snap: false,
  //             floating: false,
  //             pinned: true,
  //             centerTitle: true,
  //             flexibleSpace: LayoutBuilder(
  //                 builder: (BuildContext context, BoxConstraints constraints) {
  //               // print('constraints=' + constraints.toString());
  //               top = constraints.biggest.height;
  //               return FlexibleSpaceBar(
  //                   centerTitle: true,
  //                   title: AnimatedOpacity(
  //                       duration: Duration(milliseconds: 300),
  //                       //opacity: top == 80.0 ? 1.0 : 0.0,
  //                       opacity: 1.0,
  //                       child: Text(
  //                         top.toString(),
  //                         style: TextStyle(fontSize: 12.0),
  //                       )),
  //                 background: PodDetailsCarasol(podcast)),
  //           ),
  //           SliverFillRemaining(
  //             child: Column(
  //               children: <Widget>[Placeholder()],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class SecondaryTestScreen extends StatelessWidget {
  const SecondaryTestScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Placeholder(),
    );
  }
}
