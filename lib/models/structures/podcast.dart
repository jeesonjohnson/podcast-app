import 'dart:core';
import 'dart:math';
import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';

import 'podcast_episode.dart';
import '../managers/database_helper.dart';

import 'package:palette_generator/palette_generator.dart';

//Rss Reader Related Imports
import 'package:webfeed/domain/rss_image.dart';
import 'package:webfeed/util/helpers.dart';
import 'package:xml/xml.dart';

//Imports regarding extraction of data form url
import 'package:webfeed/webfeed.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'package:image_downloader/image_downloader.dart';

class Podcast {
  String rssAddress;
  String itunesID;
  String podcastTitle;
  String podcastImageUrl;
  String localPodcastImageUrl;
  String podcastAuthor;
  String websiteLink;
  String language;
  String copyright;
  String description;
  String isSubscribed;
  String mostCommonColor;
  List<String> podcastCategory;
  List<String> podcastKeywords;
  List<PodcastEpisode> podcastEpisodes = List<PodcastEpisode>();

  Podcast({
    this.rssAddress,
    this.itunesID,
    this.podcastTitle,
    this.podcastImageUrl,
    this.localPodcastImageUrl,
    this.podcastAuthor,
    this.websiteLink,
    this.language,
    this.copyright,
    this.description,
    this.mostCommonColor,
    this.podcastCategory,
    this.podcastKeywords,
    this.isSubscribed,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[DatabaseHelper.colRSS] = rssAddress;
    map[DatabaseHelper.colItunesID] = itunesID;
    map[DatabaseHelper.colTitle] = podcastTitle;
    map[DatabaseHelper.colImageUrl] = podcastImageUrl;
    map[DatabaseHelper.colLocalImage] = localPodcastImageUrl;
    map[DatabaseHelper.colAuthor] = podcastAuthor;
    map[DatabaseHelper.colWebsiteUrl] = websiteLink;
    map[DatabaseHelper.colLanguage] = language;
    map[DatabaseHelper.colCopyright] = copyright;
    map[DatabaseHelper.colDescription] = description;
    map[DatabaseHelper.colIsSubscribed] = isSubscribed;
    map[DatabaseHelper.colCategory] = podcastCategory.join(",");
    map[DatabaseHelper.colKeyword] = podcastKeywords.join(",");


    return map;
  }

  Podcast.fromMapObject({Map<String, dynamic> map, bool getEpisodes = true}) {
    rssAddress = map[DatabaseHelper.colRSS];
    itunesID = map[DatabaseHelper.colItunesID];
    podcastTitle = map[DatabaseHelper.colTitle];
    podcastImageUrl = map[DatabaseHelper.colImageUrl];
    localPodcastImageUrl = map[DatabaseHelper.colLocalImage];
    podcastAuthor = map[DatabaseHelper.colAuthor];
    websiteLink = map[DatabaseHelper.colWebsiteUrl];
    language = map[DatabaseHelper.colLanguage];
    copyright = map[DatabaseHelper.colCopyright];
    description = map[DatabaseHelper.colDescription];
    isSubscribed = map[DatabaseHelper.colIsSubscribed];
    podcastCategory = map[DatabaseHelper.colCategory].split(",");
    podcastKeywords = map[DatabaseHelper.colKeyword].split(",");
    // if (getEpisodes) {
    //   getPodcastEpisodes();
    // }
  }

  Future<String> getPodcastEpisodes() async {
    DatabaseHelper database = DatabaseHelper();
    await database
        .getAllEpisodes(podcastRss: this.rssAddress)
        .then((episodeData) {
      //List<PodcastEpisode> tempEpisodes= List<PodcastEpisode>();
      for (int x = 0; x < episodeData.length; x++) {
        this.podcastEpisodes.add(PodcastEpisode.fromMapObject(episodeData[x]));
      }
    });
    return "Sucess";
  }

  ///METHODS FOR GETTING PODCAST DATA FROM ONLINE
  Future<String> _rssFeedGenerator(
      {Object body, String channelOrRSS = "channel"}) async {
    var document = parse(body);
    XmlElement channelElement;
    try {
      channelElement = document.findAllElements(channelOrRSS).first;
    } on StateError {
      throw ArgumentError("$channelOrRSS not found on url");
    }
    this.podcastTitle = findElementOrNull(channelElement, "title")?.text;
    this.podcastImageUrl =
        RssImage.parse(findElementOrNull(channelElement, "image")).url;
    this.podcastAuthor = findElementOrNull(channelElement, "itunes:author")?.text;
    this.websiteLink = findElementOrNull(channelElement, "link")?.text;
    this.podcastCategory =
        channelElement.findElements("itunes:category").map((element) {
      return element.getAttribute("text");
    }).toList();
    this.language = findElementOrNull(channelElement, "language")?.text;
    this.copyright = findElementOrNull(channelElement, "copyright")?.text;
    this.description = findElementOrNull(channelElement, "description")?.text;
    this.podcastKeywords = findElementOrNull(channelElement, "itunes:keywords")
        ?.text
        ?.split(",")
        ?.toList();
    if (this.podcastKeywords == null) {
      this.podcastKeywords = [
        this.podcastTitle,
        this.podcastAuthor,
        ...this.podcastCategory
      ];
    }

    this.localPodcastImageUrl = await imageDownloader(this.podcastImageUrl);
    this.podcastEpisodes = channelElement.findElements("item").map((element) {
      return PodcastEpisode.rssParse(element, this.podcastImageUrl,
          this.rssAddress, this.localPodcastImageUrl, this.itunesID,this.podcastAuthor);
    }).toList();
    print(
        "On creation of podcast the length of podcastEpioeses is${this.podcastEpisodes.length}");
    return "Completed";
  }

  Future<String> imageDownloader(String imageUrl) async {
    Dio dio = Dio();
    var finalImageLink = "assets/images/error.jpg";
    try {
      var uniqueImageNumber =
          "${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(999999999)}";
      var dir = await getApplicationDocumentsDirectory();
      dir =
          await new Io.Directory('${dir.path}/images').create(recursive: true);
      await dio
          .download(imageUrl, "${dir.path.toString()}/$uniqueImageNumber")
          .then((onValue) {
        finalImageLink = "${dir.path.toString()}/$uniqueImageNumber";
      });
    } catch (e) {
      print(e.toString());
      print("Image Getting Failed");
    }
    print("Genereated image link is found at: $finalImageLink");
    this.localPodcastImageUrl = finalImageLink;
    return finalImageLink;
  }

//PODCAST DATA PARSER
  static Future<Podcast> genearlPodcastGetter(
      {String podcastUrl, String itunesID}) async {
    DatabaseHelper db = DatabaseHelper();
    var podcastResult = await db.getPodcasts(podcastUrl, itunesID);
    if (podcastResult.length >= 1) {
      var podcast = Podcast.fromMapObject(map: podcastResult[0]);
      await podcast.getPodcastEpisodes();
      return podcast;
    } else {
      return await onlinePodcastParser(podcastUrl, itunesID);
    }
  }

  static Future<Podcast> onlinePodcastParser(
      String podcastUrl, String itunesID) async {
    print("Currently parsing the url $podcastUrl");
    DatabaseHelper db = DatabaseHelper();
    var client = new http.Client();
    var bodyString;
    var podcastVariable = new Podcast(rssAddress: podcastUrl);
    podcastVariable.itunesID = itunesID;
    await client.get(podcastVariable.rssAddress).then((response) {
      bodyString = response.body;
      return response.body;
    }).then((body) async {
      print("Using Rss Feeder");
      await podcastVariable._rssFeedGenerator(
          body: bodyString, channelOrRSS: "channel");
      client.close();
      return podcastVariable;
    }).catchError((error) async {
      print("Using Atom Feed");
      await podcastVariable._rssFeedGenerator(
          body: bodyString, channelOrRSS: "rss");
      client.close();
      return podcastVariable;
    });
    await podcastVariable.imageDownloader(podcastVariable.podcastImageUrl);
    await db.addPodcast(podcastVariable);
    
    print(
        "the data of the podcast generated is such that :${podcastVariable.toString()}");
    return podcastVariable;
  }

  static Future<Podcast> getPodcastDataFromItunesID(String itunesID) async {
    Podcast podcast;
    try {
      var result =
          await http.get("https://itunes.apple.com/lookup?id=$itunesID");
      Map<String, dynamic> podcastLink = json.decode(result.body);
      String podcastRssLink = podcastLink["results"][0]["feedUrl"];
      podcast = await Podcast.genearlPodcastGetter(
          podcastUrl: podcastRssLink, itunesID: itunesID);
    } catch (e) {
      print("Failed extracting podcast data from itunes link");
      print(e.toString());
    }
    return podcast;
  }

  @override
  String toString() {
    return "Title:${this.podcastTitle.toString()} | imageUrl:${this.podcastImageUrl} | author:${this.podcastAuthor} | rssLink:${this.rssAddress} | websiteurl:${this.websiteLink}" +
        "| Language:${this.language} | CopyRight:${this.copyright} | PodcastKeywords:${this.podcastKeywords.toString()} | Categories:${this.podcastCategory.toString()} ||||||| LocalImageAddres:${this.localPodcastImageUrl} ||Itunes id: ${this.itunesID}";
  }
}
