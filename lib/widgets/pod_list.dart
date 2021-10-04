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

class PodList extends StatefulWidget {
  PodList({Key key}) : super(key: key);

  _PodListState createState() => _PodListState();
}

class _PodListState extends State<PodList> {
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            
            child: SelectionButton(),
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

  // void getAllPodcastData() {
  //   for (int x = 0; x < this.podcastLinks.length; x++) {
  //     int counter = 0;
  //     for (int y = 0; y < this.loadedPodcasts.length; y++) {
  //       if (this.podcastLinks[x] != this.loadedPodcasts[y].rssAddress) {
  //         counter = counter + 1;
  //       }
  //     }
  //     if (counter == this.loadedPodcasts.length) {
  //       Podcast.genearlPodcastGetter(podcastLinks[x]).then((result) {
  //         this.loadedPodcasts.add(result);
  //         if (this.loadedPodcasts.length == this.podcastLinks.length) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //           print("is loading is now fale");
  //         }
  //       });
  //     }
  //   }
  // }

  // Future<List<String>> getTopPodcasts() async {
  //   var result;
  //   try {
  //     var result = await http.get(
  //         "https://rss.itunes.apple.com/api/v1/us/podcasts/top-podcasts/all/50/explicit.json");
  //     Map<String, dynamic> jsonParsed = json.decode(result.body);
  //     List<dynamic> dataList = jsonParsed["feed"]["results"];
  //     for (int x = 0; x < dataList.length; x++) {
  //       var result = await http.get(
  //           "https://itunes.apple.com/lookup?id=${jsonParsed["feed"]["results"][x]["id"]}");
  //       Map<String, dynamic> podcastLink = json.decode(result.body);
  //       String podcastRssLink = podcastLink["results"][0]["feedUrl"];
  //       this.podcastLinks.add(podcastRssLink);
  //       //YUOU HAVE TO CHANGE THIS SO THAT IT IS NOT AS NETWORK INTENSIVE BY PREVENTING THE DATA FROM BEING CORUPUTED

  //     }
  //   } catch (e) {
  //     print("Getting podcasts top list failed");
  //     print(e.toString());
  //     this.podcastLinks = [
  //       "http://joeroganexp.joerogan.libsynpro.com/rss",
  //       "https://www.npr.org/rss/podcast.php?id=510289",
  //       "http://feeds.nightvalepresents.com/aliceisntdeadpodcast"
  //     ];
  //   }
  //   getAllPodcastData();
  //   return result;
  // }

}

class NonSplashScrollViewDesign extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
