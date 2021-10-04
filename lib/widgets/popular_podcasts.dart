import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/structures/podcast.dart';
import '../models/managers/database_helper.dart';
import '../components/pod/pod_display.dart';
import 'package:http/http.dart' as http;
import '../components/general/selection_button.dart';
import '../models/managers/episode_bloc.dart';
import 'package:provider/provider.dart';
import '../components/pod/pod_image_details_list.dart';
import 'pod_list.dart';

class PopularPodcastList extends StatefulWidget {
  PopularPodcastList({Key key}) : super(key: key);

  _PodListState createState() => _PodListState();
}

class _PodListState extends State<PopularPodcastList> {
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

    final CurrentEpisodeManager episodeBloc =
        Provider.of<CurrentEpisodeManager>(context);
    return isLoading == true
        ? loadingWidget()
        : Container(
            height: MediaQuery.of(context).size.height,
            child: ScrollConfiguration(
              behavior: NonSplashScrollViewDesign(),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: topPodcastData.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    // if(index==0){
                    //   return PodList();
                    // }
                    return new PodDetailsWithImage(
                      podcast: new Podcast(
                          podcastTitle: topPodcastData[index]["podcastName"],
                          podcastImageUrl: topPodcastData[index]["imageUrl"],
                          itunesID: topPodcastData[index]["itunesID"],
                          podcastAuthor: topPodcastData[index]["artistName"]),
                    );
                  }),
            ));//TO FIX YOU HAVE TO TAKE ALL OF THE CODE OF LISTVIEW AND MAKE IT INTO A STATLESS WIDGET
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
        podcastDataMap["artistName"] =
            jsonParsed["feed"]["results"][x]["artistName"];
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


