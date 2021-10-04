import 'package:flutter/material.dart';
import '../screens/podcast_details_screen.dart';
import '../models/structures/podcast.dart';
import '../main.dart';
import '../screens/Older/test_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Podcast args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomePage());
      case PodcastDetailsScreen.route:
        return MaterialPageRoute(
            builder: (_) => PodcastDetailsScreen(
                  currentpodcast: args,
                ));
      case MainTestScreen.route:
        return MaterialPageRoute(
            builder: (_) => MainTestScreen(
                  currentpodcast: Podcast(
                      podcastTitle: "Joe Rogan Experiance",
                      podcastImageUrl:
                          "https://images2.minutemediacdn.com/image/upload/c_fill,g_auto,h_1248,w_2220/f_auto,q_auto,w_1100/v1555921064/shape/mentalfloss/spongebob_0_0.jpg",
                      podcastAuthor: "Hoe rogan",
                      description: "Podcast form hOE rOGAN",
                      isSubscribed: "true",
                      localPodcastImageUrl:
                          "/data/user/0/com.example.podcast_app/app_flutter/images/1569515658237737155457622"),
                ));
    }
  }
}
