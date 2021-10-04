import 'dart:core';
import 'dart:math';
//Rss Reader Related Imports
import 'package:webfeed/domain/rss_image.dart';
import 'package:webfeed/util/helpers.dart';
import 'package:xml/xml.dart';
import '../managers/database_helper.dart';
import 'dart:io' as Io;
//import 'package:image_downloader/image_downloader.dart';

//Imports regarding extraction of data form url
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PodcastEpisode {
  String rssAddress;
  String itunesID;
  String currentEpisodeSeek;
  String uniqueEpisodeId;
  String episodeTitle;
  String episodeDuration;
  DateTime episodeReleaseDate;
  String episodeDescription;
  String episodeAuthor;
  String episodeImageUrl;
  String episodeLocalImageUrl;
  String episodeAduioUrl;
  String episodeLocalAduioUrl;
  String episodePodcastNumber;
  String episodeExplicit;
  List<String> episodeKeywords;

  PodcastEpisode({
    this.rssAddress,
    this.itunesID,
    this.uniqueEpisodeId,
    this.currentEpisodeSeek,
    this.episodeTitle,
    this.episodeAduioUrl,
    this.episodeAuthor,
    this.episodeDescription,
    this.episodeDuration,
    this.episodeExplicit,
    this.episodeImageUrl,
    this.episodeLocalAduioUrl,
    this.episodeLocalImageUrl,
    this.episodePodcastNumber,
    this.episodeReleaseDate,
    this.episodeKeywords,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[DatabaseHelper.colRSS] = rssAddress;
    map[DatabaseHelper.colItunesID] = itunesID;
    map[DatabaseHelper.colEpisodeID] = uniqueEpisodeId;
    map[DatabaseHelper.colAudioUrl] = episodeAduioUrl;
    map[DatabaseHelper.colLocalAudio] = episodeLocalAduioUrl;
    map[DatabaseHelper.colTitle] = episodeTitle;
    map[DatabaseHelper.colAuthor] = episodeAuthor;
    map[DatabaseHelper.colDescription] = episodeDescription;
    map[DatabaseHelper.colDuration] = episodeDuration;
    map[DatabaseHelper.colExplicit] = episodeExplicit;
    map[DatabaseHelper.colImageUrl] = episodeImageUrl;
    map[DatabaseHelper.colLocalImage] = episodeLocalImageUrl;
    map[DatabaseHelper.colNumber] = episodePodcastNumber;
    map[DatabaseHelper.colReleaseDate] = episodeReleaseDate.toIso8601String();
    map[DatabaseHelper.colKeyword] = episodeKeywords.join(",");
    return map;
  }

  PodcastEpisode.fromMapObject(Map<String, dynamic> map) {
    rssAddress = map[DatabaseHelper.colRSS];
    itunesID = map[DatabaseHelper.colItunesID];
    uniqueEpisodeId = map[DatabaseHelper.colEpisodeID];
    episodeAduioUrl = map[DatabaseHelper.colAudioUrl];
    episodeLocalAduioUrl = map[DatabaseHelper.colLocalAudio];
    episodeTitle = map[DatabaseHelper.colTitle];
    episodeAuthor = map[DatabaseHelper.colAuthor];
    episodeDescription = map[DatabaseHelper.colDescription];
    episodeDuration = map[DatabaseHelper.colDuration];
    episodeExplicit = map[DatabaseHelper.colExplicit];
    episodeImageUrl = map[DatabaseHelper.colImageUrl];
    episodeLocalImageUrl = map[DatabaseHelper.colLocalImage];
    episodePodcastNumber = map[DatabaseHelper.colNumber];
    episodeReleaseDate = DateTime.parse(map[DatabaseHelper.colReleaseDate]);
    episodeKeywords = map[DatabaseHelper.colKeyword].split(",");
  }

  //ONLINE EPISODE PARSER
  factory PodcastEpisode.rssParse(
      XmlElement element,
      String defualtImageUrl,
      String mainPodcastRssAddress,
      String localImageAddress,
      String itunesID,
      String podcastAuthor) {
    String _getOverallEpisodeNumber(
        {String season, String episode, String overallEpisode = "0"}) {
      if (season == null && episode == null && overallEpisode == null) {
        return "";
      }
      if (season != null && episode != null) {
        return "S$season:E$episode";
      }
      if (episode != null) {
        return "E$episode";
      }
      return "E$overallEpisode";
    }

    var episodeDuration = findElementOrNull(element, "itunes:duration")?.text;
    //episodeDuration = episodeDuration == null ? "0" : episodeDuration;

    episodeDuration = episodeDuration == null
        ? findElementOrNull(element, "<enclosure>")
            ?.getAttribute("length")
            ?.toString()
        : episodeDuration;
    episodeDuration = episodeDuration == null ? "0" : episodeDuration;
    var durationAmount;
    try {
      if (episodeDuration.contains(":")) {
        var episodeDurationList = episodeDuration.split(":");
        durationAmount = Duration(
            seconds: int.parse(episodeDurationList[2]),
            minutes: int.parse(episodeDurationList[1]),
            hours: int.parse(episodeDurationList[0]));
      } else {
        durationAmount = Duration(seconds: int.parse(durationAmount));
      }
    } catch (e) {
      durationAmount = Duration(hours: 1);
    }
    durationAmount = durationAmount.toString();
    //verifying the actual values
    var episodeTitle = findElementOrNull(element, "<itunes:title>")?.text;
    var episodeAuthor = findElementOrNull(element, "itunes:author")?.text;
    var episodeSummary = findElementOrNull(element, "itunes:summary")?.text;
    var podcastEpisodeNumber = _getOverallEpisodeNumber(
        episode: findElementOrNull(element, "itunes:episode")?.text,
        season: findElementOrNull(element, "itunes:season")?.text,
        overallEpisode: findElementOrNull(element, "itunes:episode")?.text);

    var episodeAudioUrl = findElementOrNull(element, "enclosure")
                ?.getAttribute("url")
                ?.toString() !=
            null
        ? findElementOrNull(element, "enclosure")
            ?.getAttribute("url")
            ?.toString()
        : findElementOrNull(element, "link")?.text;

    episodeSummary = episodeSummary == null
        ? findElementOrNull(element, "description")?.text == null
            ? "error"
            : findElementOrNull(element, "description")?.text
        : episodeSummary;
    episodeTitle = episodeTitle == null
        ? findElementOrNull(element, "title")?.text
        : "Error getting episode name";
    // episodeTitle = episodeTitle == null
    //     ? findElementOrNull(element, "title")?.text == null
    //         ? "error"
    //         : findElementOrNull(element, "title")?.text
    //     : episodeSummary;
    episodeAuthor = episodeAuthor == null ? podcastAuthor==null?"  ":podcastAuthor : episodeAuthor;

    var episodeImage = defualtImageUrl;
    if (findElementOrNull(element, "itunes:image")
            ?.getAttribute("href")
            ?.toString() !=
        null) {
      episodeImage = findElementOrNull(element, "itunes:image")
          ?.getAttribute("href")
          ?.toString();
    }

    var episodeKeywords =
        findElementOrNull(element, "itunes:keywords")?.text?.split(",");
    if (episodeKeywords == null) {
      episodeKeywords = [episodeTitle, episodeAuthor];
    }
    var uniqueEpisodeID =
        "${DateTime.now().microsecondsSinceEpoch.toString().substring(6)}${Random().nextInt(999999)}";

    return PodcastEpisode(
      rssAddress: mainPodcastRssAddress,
      itunesID: itunesID,
      uniqueEpisodeId: uniqueEpisodeID,
      episodeTitle: episodeTitle,
      episodeDescription: episodeSummary,
      episodeAuthor: episodeAuthor,
      episodeReleaseDate:
          getFormatedDateTimeRSS(findElementOrNull(element, "pubDate")?.text),
      episodeDuration: durationAmount,
      episodeImageUrl: episodeImage,
      episodeKeywords: episodeKeywords,
      episodePodcastNumber: podcastEpisodeNumber,
      episodeAduioUrl: episodeAudioUrl,
      episodeExplicit: findElementOrNull(element, "itunes:explicit")?.text,
      episodeLocalImageUrl: localImageAddress,
    );
  }
  @override
  String toString() {
    return "| Local Episode Image:${this.episodeLocalImageUrl} ||Duration:${this.episodeDuration.toString()} | imageUrl:${this.episodeImageUrl} | author:${this.episodeAuthor} | title:${this.episodeTitle} | audiourl:${this.episodeAduioUrl}" +
        "| Description:${this.episodeDescription} | ReleaseDate:${this.episodeReleaseDate.toIso8601String()} | PodcastKeywords:${this.episodeKeywords.toString()} | podcastNumber:${this.episodePodcastNumber.toString()} | explicit:${this.episodeExplicit} " +
        "  | Episode id:${this.uniqueEpisodeId}";
  }

  // Future<String> imageDownloader(String imageUrl) async {
  //   Dio dio = Dio();
  //   var finalImageLink = "assets/images/error.jpg";
  //   try {
  //     var uniqueImageNumber =
  //         "${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(999999999)}";
  //     var dir = await getApplicationDocumentsDirectory();
  //     dir =
  //         await new Io.Directory('${dir.path}/images').create(recursive: true);
  //     await dio
  //         .download(imageUrl, "${dir.path.toString()}/$uniqueImageNumber")
  //         .then((onValue) async {
  //       finalImageLink = "${dir.path.toString()}/$uniqueImageNumber";
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     print("Image Getting Failed");
  //   }
  //   print("Genereated image link is found at: $finalImageLink");
  //   this.episodeLocalImageUrl = finalImageLink;
  //   return finalImageLink;
  // }
}
