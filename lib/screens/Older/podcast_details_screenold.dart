import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:podcast_app/models/structures/constants.dart';
import '../../models/structures/podcast.dart';

import '../../components/pod/pod_ep_list_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../components/music/bottom_music_controls.dart';
import '../../models/managers/episode_bloc.dart';
import 'package:provider/provider.dart';
import '../../components/pod/pod_detail_carasol.dart';
import '../../components/general/search_bar.dart';

Podcast podcast;

class PodcastDetailsScreen extends StatelessWidget {
  static const String route = "pod_details_screen";
  PodcastDetailsScreen({@required Podcast currentpodcast}) {
    podcast = currentpodcast;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => CurrentEpisodeManager(),
      child: Scaffold(
        persistentFooterButtons: <Widget>[
          MusicControls(
            getPastEpisodes: false,
          ),
        ],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarSize),
          child: AppBar(
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 25),
                child: Icon(Icons.arrow_back,
                    color: Theme.of(context).accentColor),
              ),
            ),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 25),
                child: Icon(Icons.search),
              )
            ],
          ),
        ),
        body: MainPodData(),
      ),
    );
  }
}

class MainPodData extends StatefulWidget {
  MainPodData();

  _MainPodDataState createState() => _MainPodDataState();
}

class _MainPodDataState extends State<MainPodData> {
  bool isLoading = true;
  @override
  void initState() {
    getPodcastData(podcast.itunesID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading
        ? loadingWidget()
        : Column(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: PodDetailsCarasol(podcast),
                fit: FlexFit.tight,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              //SearchBar(),
              Flexible(
                flex: 21, fit: FlexFit.tight, child: Placeholder(),
                // Container(
                //   child: ListView.builder(
                //     scrollDirection: Axis.vertical,
                //     itemCount: podcast.podcastEpisodes.length,
                //     itemBuilder: (context, index) {
                //       return PodcastEpListItem(
                //           podcastEpisode: podcast.podcastEpisodes[index]);
                //     },
                //   ),
                // ),
              )
            ],
          ));
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
