import 'package:media_player/media_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:media_player/data_sources.dart';
import 'package:podcast_app/models/managers/episode_bloc.dart';
import 'database_helper.dart';
import '../structures/podcast_episode.dart';

class PodcastMediaManager {
  static PodcastMediaManager _singletonMediaManager;
  static MediaPlayer _mediaPlayerOG;
  DatabaseHelper db = DatabaseHelper();

  factory PodcastMediaManager() {
    if (_singletonMediaManager == null) {
      _singletonMediaManager = new PodcastMediaManager._internal();
    }
    return _singletonMediaManager;
  }

  PodcastMediaManager._internal();

  Future<MediaPlayer> get mediaPlayer async {
    if (_mediaPlayerOG == null) {
      _mediaPlayerOG =
          MediaPlayerPlugin.create(isBackground: true, showNotification: true);
      await _mediaPlayerOG.initialize();
      DatabaseHelper db = DatabaseHelper();
      await setPodcastEpisodeSource(
          podEpisode: db.getCurrentPodcastEpisode(), autoPlay: false);
    }
    return _mediaPlayerOG;
  }

  MediaPlayer getMediaPlayer() {
    return _mediaPlayerOG;
  }

  Future<String> setPodcastEpisodeSource(
      {PodcastEpisode podEpisode,
      bool playFromOnline = true,
      bool autoPlay = true,
      String currentEpisodeSeek}) async {
    MediaPlayer _mediaPlayer = await mediaPlayer;
    DatabaseHelper db = DatabaseHelper();
    db.setCurrentPodcastEpisode(podEpisode);
    MediaFile media;
    if (playFromOnline || podEpisode.episodeLocalAduioUrl == null) {
      String episodeUrl = await _getTruePodcastLink(podEpisode.episodeAduioUrl);
      media = MediaFile(
        title: podEpisode.episodeTitle,
        type: "audio",
        source: episodeUrl,
        desc: podEpisode.episodeAuthor,
      );
    } else {
      media = MediaFile(
        title: podEpisode.episodeTitle,
        type: "audio",
        source: podEpisode.episodeLocalAduioUrl,
        desc: podEpisode.episodeAuthor,
      );
    }
    await _mediaPlayer.setSource(media);
    if (currentEpisodeSeek != null) {
      _mediaPlayer.seek(int.parse(currentEpisodeSeek));
    }
    if (autoPlay) {
      await _mediaPlayer.play();
    }

    return "Completed";
  }

  Future<String> stopPlayer() async {
    MediaPlayer _mediaPlayer = await mediaPlayer;
    Duration mediaPlayerLocation = await _mediaPlayer.position;
    await db.addLastPlayedEpisode(
        db.getCurrentPodcastEpisode(), mediaPlayerLocation.toString());
    await _mediaPlayer.dispose();
    return "Stopped";
  }

  Future<void> pausePlayer() async {
    MediaPlayer _mediaPlayer = await mediaPlayer;
    Duration mediaPlayerLocation = await _mediaPlayer.position;
    await db.addLastPlayedEpisode(
        db.getCurrentPodcastEpisode(), mediaPlayerLocation.toString());
    await _mediaPlayer.pause();
  }

  Future<String> playPlayer() async {
    MediaPlayer _mediaPlayer = await mediaPlayer;
    await _mediaPlayer.play();
    return "Compelted";
  }

  Future<bool> currentPlayState() async {
    MediaPlayer _mediaPlayer = await mediaPlayer;
    print("Current status of notifier is ${_mediaPlayer.valueNotifier.value.isPlaying}");
    return _mediaPlayer.valueNotifier.value.isPlaying;
    
  }

  Future<void> togglePlayerStatus()async{

    MediaPlayer _mediaPlayer = await mediaPlayer;
    if(_mediaPlayer.valueNotifier.value.isPlaying){
      pausePlayer();
    }else{
      playPlayer();
    }
  }


  Future<String> _getTruePodcastLink(String url) async {
    http.Response result = await http.head(url);
    String resultUrl = result.url;
    Map<String, List<String>> networkSources = {
      "libsyn": ["http://", "https://secure-"],
    };

    List<String> networkSourcesList = networkSources.keys.toList();
    for (int x = 0; x < networkSourcesList.length; x++) {
      if (resultUrl.contains(networkSourcesList[x])) {
        resultUrl = resultUrl.replaceFirst(
            networkSources[networkSourcesList[x]][0],
            networkSources[networkSourcesList[x]][1]);
      }
    }
    return resultUrl;
  }
}
