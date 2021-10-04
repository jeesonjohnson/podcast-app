import 'package:flutter/material.dart';

import  '../structures/podcast.dart';
import 'package:sqflite/sqflite.dart';
import "dart:async";
import 'dart:io';
import '../structures/podcast_episode.dart';
import 'episode_bloc.dart';
import 'package:media_player/media_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:media_player/data_sources.dart';
import 'package:provider/provider.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  static PodcastEpisode _currentEpisode;
  //MediaPlayer _mediaPlayer;

  static PodcastEpisode currentPodcast = PodcastEpisode(
      episodeAduioUrl:
          "https://hwcdn.libsyn.com/p/0/2/0/020f0bde1d02f59d/mmashow079.mp3?c_id=52424051&cs_id=52424051&expiration=1568939930&hwt=2a1f8c440a23458d2653db5c3649e88b");


  /*
  Podcast Table and resulting fields
  */
  static const String podcastTable = "podcasts_table";
  static const String colTitle = "podcast_title";
  static const String colName = "podcast_name";
  static const String colRSS = "podcast_rss_address";
  static const String colItunesID = "podcast_itunes_id";
  static const String colImageUrl = "podcast_url";
  static const String colLocalImage = "podcast_local_image_location";
  static const String colAuthor = "podcast_author";
  static const String colWebsiteUrl = "podcast_website_link";
  static const String colLanguage = "podcast_language";
  static const String colCopyright = "podcast_copyright";
  static const String colDescription = "podcast_description";
  static const String colIsSubscribed = "podcast_subscription";
  static const String colCategory = "podcast_category";
  static const String colKeyword = "podcast_keyword";

  /*
  Podcast Episode Feilds
  */
  static const String episodeTable = "podcastEP_table";
  static const String colDuration = "episode_duration";
  static const String colAudioUrl = "episode_url";
  static const String colLocalAudio = "episode_local_url";
  static const String colReleaseDate = "episode_release_date";
  static const String colNumber = "episode_number";
  static const String colEpisodeID = "episode_id";
  static const String colExplicit = "episode_explicit_rating";

/*
Previus Podcast variables
*/

  static const String playedEpisodesTable = "playedEP_table";
  static const String colLastPlayLocation = "last_played_Location";
  static const String colEpisodePlayedTime = "episode_play_time";

/*
Geberal Podcast creation Strings
*/
  final String podcastTableCreate =
      "CREATE TABLE $podcastTable($colRSS LONGTEXT ,$colItunesID TEXT, $colTitle TEXT, $colImageUrl TEXT, $colLocalImage TEXT, $colAuthor TEXT, $colWebsiteUrl TEXT, $colLanguage TEXT, $colCopyright TEXT, $colDescription LONGTEXT, $colCategory LONGTEXT, $colKeyword LONGTEXT,$colIsSubscribed TEXT)";
  final String podcastEpisodeTableCreate =
      "CREATE TABLE $episodeTable($colEpisodeID LONGTEXT ,$colRSS TEXT, $colItunesID TEXT, $colAudioUrl LONGTEXT, $colTitle TEXT, $colDuration TEXT, $colReleaseDate DATETIME, $colDescription LONGTEXT, $colAuthor TEXT, $colImageUrl LONGTEXT, $colLocalAudio LONGTEXT, $colLocalImage LONGTEXT, $colNumber TEXT, $colExplicit TEXT, $colKeyword LONGTEXT)";
  final String lastPlayedEpisodeTableCreate =
      "CREATE TABLE $playedEpisodesTable($colEpisodeID TEXT, $colEpisodePlayedTime DATETIME, $colLastPlayLocation TEXT)";

  DatabaseHelper.createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabse();
      _currentEpisode = await getLastPlayedEpisode();
      // _mediaPlayer =
      //     MediaPlayerPlugin.create(isBackground: true, showNotification: true);
      // await _mediaPlayer.initialize();
    }
    return _database;
  }

  Future<Database> initializeDatabse() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "podcast1_data.db";
    var mainDatabase =
        openDatabase(path, version: 1, onCreate: _createDatabase);
    return mainDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {
    //  await db.execute(
    //     "CREATE TABLE $podcastTable($colRSS TEXT PRIMARY KEY,$colItunesID TEXT, $colTitle TEXT, $colImageUrl TEXT, $colLocalImage TEXT, $colAuthor TEXT, $colWebsiteUrl TEXT, $colLanguage TEXT, $colCopyright TEXT, $colDescription LONGTEXT, $colCategory LONGTEXT, $colKeyword LONGTEXT,$colIsSubscribed TEXT)");
    // await db.execute(
    //     "CREATE TABLE $episodeTable(FOREIGN KEY($colRSS) REFERENCES $podcastTable($colRSS),$colItunesID TEXT, $colAudioUrl LONGTEXT, $colTitle TEXT, $colDuration TEXT, $colReleaseDate DATETIME, $colDescription LONGTEXT, $colAuthor TEXT, $colImageUrl LONGTEXT, $colLocalAudio LONGTEXT, $colLocalImage LONGTEXT, $colNumber TEXT, $colExplicit TEXT, $colKeyword LONGTEXT)");

    await db.execute(podcastTableCreate);
    await db.execute(podcastEpisodeTableCreate);
    await db.execute(lastPlayedEpisodeTableCreate);
  }

  void setCurrentPodcastEpisode(PodcastEpisode episode) {
    _currentEpisode = episode;
    //notifyListeners();
  }

  PodcastEpisode getCurrentPodcastEpisode() {
    return _currentEpisode;
  }



  ///####################################################################Functions Regarding Last Played episodes########################################################################

  Future<void> deleteAllPlayedEpisodeStatus() async {
    Database db = await this.database;
    await db.rawDelete("DROP TABLE IF EXISTS $playedEpisodesTable");
    await db.execute(lastPlayedEpisodeTableCreate);
    print("Finished deleting last played table");
  }

  Future<PodcastEpisode> getLastPlayedEpisode() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(playedEpisodesTable,
        orderBy: "$colEpisodePlayedTime DESC");
  
    if (result.length != 0) {
      print("PODCASTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT ${result[0][colEpisodeID]}");
      List<Map<String, dynamic>> episodeRequest = await db.query(episodeTable,
          orderBy: "$colTitle ASC", 
          where: "$colEpisodeID = \"${result[0][colEpisodeID]}\"");
          print("latest EpisodeStrucutre:::::${episodeRequest.toString()}");
          PodcastEpisode episode=PodcastEpisode.fromMapObject(episodeRequest[0]);
          episode.currentEpisodeSeek=episodeRequest[0][colEpisodePlayedTime];
      return episode;
    } else {
      return null;
    }
  }

  Future<void> addLastPlayedEpisode(
      PodcastEpisode episode, String episodePlayedUpToLocation) async {
    Database db = await this.database;
    var episodeResult =
        await getPodcastEpisode(episodeUnqiueID: episode.uniqueEpisodeId);
    if (episodeResult != null) {
      await db.rawDelete(
          "DELETE FROM $playedEpisodesTable WHERE $colEpisodeID=\"${episode.uniqueEpisodeId}\"");
    }
    await db.rawInsert(
        "INSERT INTO $playedEpisodesTable ($colEpisodeID, $colEpisodePlayedTime, $colLastPlayLocation) VALUES (${episode.uniqueEpisodeId},\"${DateTime.now().toIso8601String()}\",\"${episodePlayedUpToLocation.toString()}\");");
  }

  Future<List<PodcastEpisode>> getAllLastPlayedEpisodes() async {
    Database db = await this.database;
    var result = await db.query(playedEpisodesTable,
        orderBy: "$colEpisodePlayedTime DESC");
    List<PodcastEpisode> episodeList = [];
    for (int x = 0; x < result.length; x++) {
      episodeList.add(await getPodcastEpisode(episodeUnqiueID: result[x][colEpisodeID]));
    }

    return episodeList;
  }

  //##################################################################General Database Functions##############################################################

  //Functions regarding podcasts
  Future<List<Map<String, dynamic>>> getAllSubscribedPodcasts() async {
    Database db = await this.database;
    var result = await db.query(podcastTable,
        orderBy: "$colTitle ASC", where: "$colIsSubscribed = \"true\"");
    return result;
  }

  Future<int> deleteAllTables() async {
    Database db = await this.database;
    db.rawDelete("DROP TABLE IF EXISTS $podcastTable");
    db.rawDelete("DROP TABLE IF EXISTS $episodeTable");
    db.rawDelete("DROP TABLE IF EXISTS $playedEpisodesTable");

    await db.execute(podcastTableCreate);
    await db.execute(podcastEpisodeTableCreate);
    await db.execute(lastPlayedEpisodeTableCreate);
    return 1;
  }

  Future<int> addPodcast(Podcast podcast) async {
    Database db = await this.database;
    var result = 0;
    try {
      result = await db.insert(podcastTable, podcast.toMap());
      for (int x = 0; x < podcast.podcastEpisodes.length; x++) {
        await db.insert(episodeTable, podcast.podcastEpisodes[x].toMap());
      }
      print("Sucessfully added podcast");
    } catch (e) {
      print(
          "Adding Podcast faileddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
      print(e.toString());
    }

    return result;
  }

  Future<int> updatePodcast(Podcast podcast) async {
    Database db = await this.database;
    var result = await db.update(
      podcastTable,
      podcast.toMap(),
      where: '$colRSS = \"${podcast.rssAddress}\"',
    );
    db.rawDelete(
        "DELETE FROM $episodeTable WHERE $colRSS=\"${podcast.rssAddress}\"");

    for (int x = 0; x < podcast.podcastEpisodes.length; x++) {
      await db.insert(episodeTable, podcast.podcastEpisodes[x].toMap());
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getPodcasts(
      String podcastRss, String itunesID) async {
    Database db = await this.database;
    var result;
    if (itunesID == null) {
      result = await db.query(
        podcastTable,
        where: '$colRSS = \"$podcastRss\"',
      );
    } else {
      result = await db.query(
        podcastTable,
        where: '$colItunesID = \"$itunesID\"',
      );
    }
    return result;
  }

  Future<String> isPodcastSubsribed(String itunesID) async {
    Database db = await this.database;
    var result = await db.query(podcastTable,
        orderBy: "$colTitle ASC",
        where: "$colIsSubscribed = \"true\" AND $colItunesID = \"$itunesID\"");
    if (result.length >= 1) {
      return "true";
    } else {
      return "false";
    }
  }

  Future<String> invertPodcastSubscription(String itunesID) async {
    //REMEMEMBER IN THE FUTURE YOU HAVE TO WRITE  METHOD TO DELETE ALL THE LOCALLY STORED EPISODES.... As well As updating the values accordingly
    Database db = await this.database;
    try {
      var result = await db.query(podcastTable,
          orderBy: "$colTitle ASC", where: "$colItunesID = \"$itunesID\"");
      if (result.length > 0) {
        Podcast podcast = Podcast.fromMapObject(map: result[0]);
        podcast.isSubscribed =
            podcast.isSubscribed == "true" ? "false" : "true";
        String updateCommand="UPDATE ${podcastTable} SET ${colIsSubscribed}=\"${podcast.isSubscribed}\" WHERE ${colItunesID}==${podcast.itunesID}";
        var updateResult = await db.rawUpdate(updateCommand);
        print("Completed inversion");
      } else {
        await Podcast.getPodcastDataFromItunesID(itunesID);
        print("Newly added the podcast");
      }
    } catch (e) {
      print("Failed inverting podcastSubscription");
      print(e.toString());
    }
    return "Complted";
  }

  //###################################################################All PODCAST EPSIODE FUNCTIONS############################################

  Future<int> addPodcastEpisode(PodcastEpisode episode) async {
    Database db = await this.database;
    var result = 0;
    try {
      result = await db.insert(episodeTable, episode.toMap());
    } catch (e) {
      print("Adding Podcast failed");
    }
    return result;
  }

  Future<int> updatePodcastEpisode(PodcastEpisode episode) async {
    Database db = await this.database;
    var result = await db.update(episodeTable, episode.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllEpisdoesFromTable() async {
    Database db = await this.database;
    var result = await db.query(episodeTable, orderBy: "$colTitle ASC");
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllEpisodes(
      {Podcast podcast, String podcastRss = "null"}) async {
    Database db = await this.database;
    //If the user enters a podcast object the episodes are gathered accordingly.
    var rssLink = podcastRss == "null" ? podcast.rssAddress : podcastRss;
    //Depedning on the rss feed the approrpatie episodes are generated.
    var result = await db.query(episodeTable,
        orderBy: "$colReleaseDate DESC", where: "$colRSS = \"$rssLink\"");
    return result;
  }

  Future<PodcastEpisode> getPodcastEpisode({String episodeUnqiueID,String episodeTitle}) async {
    Database db = await this.database;
    var result;
    if(episodeTitle==null){
          result = await db.query(episodeTable,
        orderBy: "$colReleaseDate DESC",
        where: "$colEpisodeID = $episodeUnqiueID");
    }else{
          result = await db.query(episodeTable,
        orderBy: "$colReleaseDate DESC",
        where: "$colTitle = \"$episodeTitle\"");
    }
    if (result.length > 0) {
      return PodcastEpisode.fromMapObject(result[0]);
    } else {
      return null;
    }
  }
}

///#################################################################### OLD MEDIA PLAYER FUNCTIONSs########################################################################
// Future<String> setMediaSource(
//     {PodcastEpisode podEpisode, bool playFromOnline = true}) async {
//   setCurrentPodcastEpisode(podEpisode);
//   MediaFile media;
//   if (playFromOnline || podEpisode.episodeLocalAduioUrl == null) {
//     String episodeUrl = await _getTruePodcastLink(podEpisode.episodeAduioUrl);
//     media = MediaFile(
//       title: podEpisode.episodeTitle,
//       type: "video",
//       source: episodeUrl,
//       desc: podEpisode.episodeAuthor,
//     );
//   } else {
//     media = MediaFile(
//       title: podEpisode.episodeTitle,
//       type: "video",
//       source: podEpisode.episodeLocalAduioUrl,
//       desc: podEpisode.episodeAuthor,
//     );
//   }
//   await _mediaPlayer.setSource(media);
//   await _mediaPlayer.play();
//   return "Completed";
// }

// Future<String> stopPlayer() async {
//   await _mediaPlayer.dispose();
//   return "Stopped";
// }

// Future<String> startPlayer() async {
//   await _mediaPlayer.play();
//   return "Compelted";
// }

// Future<String> _getTruePodcastLink(String url) async {
//   http.Response result = await http.head(url);
//   String resultUrl = result.url;
//   Map<String, List<String>> networkSources = {
//     "libsyn": ["http://", "https://secure-"],
//   };

//   List<String> networkSourcesList = networkSources.keys.toList();
//   for (int x = 0; x < networkSourcesList.length; x++) {
//     if (resultUrl.contains(networkSourcesList[x])) {
//       resultUrl = resultUrl.replaceFirst(
//           networkSources[networkSourcesList[x]][0],
//           networkSources[networkSourcesList[x]][1]);
//     }
//   }
//   return resultUrl;
// }
