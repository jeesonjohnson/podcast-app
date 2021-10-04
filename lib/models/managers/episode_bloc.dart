import '../structures/podcast_episode.dart';
import 'package:flutter/foundation.dart';
import 'database_helper.dart';
class CurrentEpisodeManager extends ChangeNotifier{

  // static final CurrentEpisodeManager _singleton = new CurrentEpisodeManager._internal();

  // factory CurrentEpisodeManager() {
  //   return _singleton;
  // }

  // CurrentEpisodeManager._internal();
  DatabaseHelper db=DatabaseHelper();

  PodcastEpisode _currentEpisode=PodcastEpisode();
  String test="original";
  
set currentEpisode(PodcastEpisode episode){
  _currentEpisode=episode;

  db.setCurrentPodcastEpisode(episode);
  notifyListeners();
}

  PodcastEpisode get currentEpisode{
    
    return db.getCurrentPodcastEpisode();
  }

  set testText(String text){
    test=text;
    notifyListeners();
  }


}
