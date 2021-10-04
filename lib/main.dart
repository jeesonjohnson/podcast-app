//Dart Imports

//Flutter imports
import 'package:flutter/material.dart';
import 'models/managers/database_helper.dart';
import 'models/structures/podcast_episode.dart';
import 'models/managers/podcat_media_player.dart';
//import 'package:image_downloader/image_downloader.dart';
import 'widgets/test_screen.dart';
//File Imports
import 'models/structures/constants.dart';
import 'components/pod/pod_display.dart';
import 'package:marquee/marquee.dart';

import 'widgets/pod_list.dart';
import 'generators/route_generator.dart';
import 'components/music/bottom_music_controls.dart';
import 'package:provider/provider.dart';
import 'models/managers/episode_bloc.dart';
import 'components/general/search_bar.dart';
import 'components/music/modal_music_player.dart';
import 'screens/Older/test_screen.dart';
import 'widgets/popular_podcasts.dart';
import 'components/general/selection_button.dart';
import 'components/pod/pod_image_details_list.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:podcast_app/models/structures/constants.dart';
import 'models/structures/podcast.dart';

import 'components/pod/pod_ep_list_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'components/music/bottom_music_controls.dart';
import 'models/managers/episode_bloc.dart';
import 'package:provider/provider.dart';
import 'components/pod/pod_detail_carasol.dart';
import 'components/general/search_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PodcastApp',
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        canvasColor: Colors.transparent,
        primarySwatch: primaryColorBlackBG,
        accentColor: accentColorRed,
        scaffoldBackgroundColor: primaryColorBlackBG,
        errorColor: Colors.red,
        fontFamily: "NotoSans",
        primaryIconTheme: IconThemeData(color: accentColorRed),
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: "NotoSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: accentColorRed),
              body1: TextStyle(
                color: textColorGreen,
                fontFamily: "SourceSansPro",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              body2: TextStyle(
                color: unselectedTextColor,
                fontFamily: "SourceSansPro",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
        buttonColor: buttonBackgroundColor,
        buttonTheme: ButtonThemeData(
            buttonColor: buttonBackgroundColor,
            textTheme: ButtonTextTheme.normal),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (context) => CurrentEpisodeManager(),
        child: Scaffold(
            drawer: Drawer(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: primaryColorBlackBG,
              ),
            ),
            persistentFooterButtons: <Widget>[
              MusicControls(
                getPastEpisodes: true,
              )
            ],
            body: MainList()));
  }
}

class MainList extends StatefulWidget {
  MainList({Key key}) : super(key: key);

  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  bool isLoading = true;
  String loadingText = "loading";
  int counter = 0;

  List<Map<String, String>> topPodcastData = [];
  List<Podcast> loadedPodcasts = [];
  List<PodDisplay> podDisplayCache = [];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      getTopPodcasts();
    }
    // else{
    //   downloadAllPodcastData();
    // }
    final CurrentEpisodeManager episodeBloc =
        Provider.of<CurrentEpisodeManager>(context);
    return isLoading
        ? loadingWidget()
        : NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  actions: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 30,
                          ),
                          color: unselectedTextColor,
                          onPressed: () {
                            //ToBEIMPLEMENTED
                          },
                        ))
                  ],
                  expandedHeight: 90,
                  floating: false,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
                        opacity: top == 80 ? 0.9 : 0.0,
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "Discover",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 20),
                          ),
                        ),
                      ),
                      background: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 22),
                          child: Container(
                            child: Text(
                              "Discover",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(fontSize: 45),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ];
            },
            body: ListView.builder(
              padding: EdgeInsets.all(14),
              itemCount: topPodcastData.length,
              itemBuilder: (context, index) {
                print("ABCD LENGTH ${topPodcastData.length}");
                if (index <= 0) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: crossPodcastList(firstChoice: "Popular",secondChoice: "Trending"));
                } else if(index==1) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: crossPodcastList());
                      }
                      else{
                          Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: crossPodcastList());
                      }
                  // if (topPodcastData[index]["artistName"] == null) {
                  //   topPodcastData[index]["artistName"] = "Error getting name";
                  // }

                  // return Container(
                  //   child: Text(topPodcastData[index]["podcastName"]),
                  // );
                  // return downPodcastList(
                  //   new Podcast(
                  //       podcastTitle: topPodcastData[index]["podcastName"],
                  //       podcastImageUrl: topPodcastData[index]["imageUrl"],
                  //       itunesID: topPodcastData[index]["itunesID"],
                  //       podcastAuthor: topPodcastData[index]["artistName"]),
                  // );
                
              },
            ),
          );
  }

  Widget downPodcastList(Podcast podcast) {
    return Container(
      color: buttonBackgroundColor,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed("pod_details_screen", arguments: podcast);
        },
        highlightColor: Colors.red,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: podcast.podcastImageUrl,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: podcast.podcastTitle.length < 24
                          ? Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                podcast.podcastTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(fontSize: 20),
                              ))
                          : Marquee(
                              velocity: 30,
                              text: podcast.podcastTitle,
                              blankSpace: 30,
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 20),
                            ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: podcast.podcastAuthor.length < 37
                          ? Text(
                              "   ${podcast.podcastAuthor}",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(fontSize: 16),
                            )
                          : Marquee(
                              text: podcast.podcastAuthor,
                              blankSpace: 150,
                              velocity: 30,
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget crossPodcastList({String firstChoice,String secondChoice}) {
    Widget currentSelection;
    if (firstChoice==null) {
      currentSelection = SelectionButton();
    } else {
      currentSelection = SelectionButton(
        firstChoice: firstChoice,
        secondChoice: secondChoice,
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: currentSelection,
          ),
          SizedBox(
            width: 0,
            height: 10,
          ),
          Container(
            height: 181,
            child: isLoading == true
                ? loadingWidget()
                : ScrollConfiguration(
                    behavior: NonSplashScrollViewDesign(),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topPodcastData.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return new PodDisplay(
                            podcast: new Podcast(
                              podcastTitle: topPodcastData[index]
                                  ["podcastName"],
                              podcastImageUrl: topPodcastData[index]
                                  ["imageUrl"],
                              itunesID: topPodcastData[index]["itunesID"],
                            ),
                          );
                        }),
                  ),
          ),
        ],
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
            Text("Podcasts are loading...")
          ],
        ),
      ),
    );
  }

  Future<List<String>> getTopPodcasts() async {
    var result;
    try {
      var result = await http.get(
          "https://rss.itunes.apple.com/api/v1/us/podcasts/top-podcasts/all/100/explicit.json");
      Map<String, dynamic> jsonParsed = json.decode(result.body);
      List<dynamic> dataList = jsonParsed["feed"]["results"];
      for (int x = 0; x < dataList.length; x++) {
        Map<String, String> podcastDataMap = new Map<String, String>();
        //Remember to change this from jsonParsed["feed"]["results"][x]["name"] to datalist...
        podcastDataMap["itunesID"] = jsonParsed["feed"]["results"][x]["id"];
        podcastDataMap["podcastName"] =
            jsonParsed["feed"]["results"][x]["name"];
        podcastDataMap["imageUrl"] =
            jsonParsed["feed"]["results"][x]["artworkUrl100"];
        topPodcastData.add(podcastDataMap);
        //YUOU HAVE TO CHANGE THIS SO THAT IT IS NOT AS NETWORK INTENSIVE BY PREVENTING THE DATA FROM BEING CORUPUTED
        print("Loading data");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Getting podcasts top list failed");
      print(e.toString());
    }
    return result;
  }
}

class NonSplashScrollViewDesign extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
