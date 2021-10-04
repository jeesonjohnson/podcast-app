// //Dart Imports

// //Flutter imports
// import 'package:flutter/material.dart';
// import 'models/managers/database_helper.dart';
// import 'models/structures/podcast_episode.dart';
// import 'models/managers/podcat_media_player.dart';
// //import 'package:image_downloader/image_downloader.dart';
// import 'widgets/test_screen.dart';
// //File Imports
// import 'models/structures/constants.dart';
// import 'components/pod/pod_display.dart';
// import 'widgets/pod_list.dart';
// import 'generators/route_generator.dart';
// import 'components/music/bottom_music_controls.dart';
// import 'package:provider/provider.dart';
// import 'models/managers/episode_bloc.dart';
// import 'components/general/search_bar.dart';
// import 'components/music/modal_music_player.dart';
// import 'screens/Older/test_screen.dart';
// import 'widgets/popular_podcasts.dart';

// void main() {
//   // DatabaseHelper db = DatabaseHelper();
//   // db.setCurrentPodcastEpisode(PodcastEpisode(episodeTitle: "mainPodcast"));
//   // PodcastMediaManager mediaManager = PodcastMediaManager();
//   // PodcastEpisode lastPlayedEpisode = await db.getLastPlayedEpisode();
//   // print("starting");
//   // if (lastPlayedEpisode != null) {
//   //   print("1234567890");
//   //   print(lastPlayedEpisode.toString());
//   //   await mediaManager.setPodcastEpisodeSource(
//   //     podEpisode: lastPlayedEpisode,
//   //     autoPlay: false,
//   //     currentEpisodeSeek: lastPlayedEpisode.currentEpisodeSeek,
//   //   );
//   // }

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PodcastApp',
//       initialRoute: "/",
//       onGenerateRoute: RouteGenerator.generateRoute,
//       theme: ThemeData(
//         canvasColor: Colors.transparent,
//         primarySwatch: primaryColorBlackBG,
//         accentColor: accentColorRed,
//         scaffoldBackgroundColor: primaryColorBlackBG,
//         errorColor: Colors.red,
//         fontFamily: "NotoSans",
//         primaryIconTheme: IconThemeData(color: accentColorRed),
//         textTheme: ThemeData.light().textTheme.copyWith(
//               title: TextStyle(
//                   fontFamily: "NotoSans",
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: accentColorRed),
//               body1: TextStyle(
//                 color: textColorGreen,
//                 fontFamily: "SourceSansPro",
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//               body2: TextStyle(
//                 color: unselectedTextColor,
//                 fontFamily: "SourceSansPro",
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//         buttonColor: buttonBackgroundColor,
//         buttonTheme: ButtonThemeData(
//             buttonColor: buttonBackgroundColor,
//             textTheme: ButtonTextTheme.normal),
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key key}) : super(key: key);
  

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       builder: (context) => CurrentEpisodeManager(),
//       child: Scaffold(
        
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(appBarSize),
//           child: AppBar(
//             elevation: 0.0,
//             actions: <Widget>[
//               Container(
//                 padding: EdgeInsets.only(right: 1, top: 8),
//                 child: Container(
//                   // decoration: BoxDecoration(
//                   //   border: Border.all(
//                   //     width: 2.0,
//                   //     color: Colors.grey,
//                   //   ),
//                   //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                   // ),
//                   //padding: EdgeInsets.only(right: 4),
//                   child: FlatButton(
//                     //shape: RoundedRectangleBorder(),
//                     child: Icon(
//                       Icons.search,
//                       size: 30,
//                       color: Theme.of(context).textTheme.body2.color,
//                     ),

//                     // child: Container(
//                     //   child: Row(
//                     //     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     //     children: <Widget>[
//                     //       Icon(
//                     //         Icons.search,
//                     //         color: Theme.of(context).textTheme.body2.color,
//                     //       ),
//                     // SizedBox(
//                     //   width: 14,
//                     // ),
//                     // Container(
//                     //   child: Text(
//                     //     "Search",
//                     //     style: Theme.of(context)
//                     //         .textTheme
//                     //         .body2
//                     //         .copyWith(fontWeight: FontWeight.normal),
//                     //   ),
//                     // ),
//                     //     ],
//                     //   ),
//                     // ),
//                     //splashColor: Theme.of(context).textTheme.body1.color,
//                     onPressed: () {
//                       print("YOU NEED TO IMPLEMENT THIS MEHTOD");
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         drawer: Drawer(
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: primaryColorBlackBG,
//             //Add Stuff for code here
//           ),
//         ),
//         persistentFooterButtons: <Widget>[
//           MusicControls(
//             getPastEpisodes: true,
//           )
//         ],
//         body:
        
        
//          Container(
//           //padding: EdgeInsets.only(left: 18),
//           child: 
          
//           Column(
//             children: <Widget>[
//               // Container(
//               //   padding: EdgeInsets.only(left: 10, right: 10,top: 10),
//               //   child: SearchBar(),
//               // ),
//               Container(
//                 padding: EdgeInsets.only(left: 18),
//                 child: Text(
//                   "Discover",
//                   style: Theme.of(context).textTheme.title.copyWith(
//                         fontSize: 42,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
              
//               //TestScreen(),
//                                                             // FlatButton(
//                                                             //   child: Text(
//                                                             //     "Delete all Database Values",
//                                                             //     style: TextStyle(color: Colors.white),
//                                                             //   ),
//                                                             //   onPressed: () {
//                                                             //     DatabaseHelper db = DatabaseHelper();
//                                                             //     db.deleteAllTables();
//                                                             //     print("Finished deleting sql databasese");
//                                                             //   },
//                                                             // ),
//                                                             // FlatButton(
//                                                             //   child: Text(
//                                                             //     "Print all epsiode data",
//                                                             //     style: TextStyle(color: Colors.white),
//                                                             //   ),
//                                                             //   onPressed: () async {
//                                                             //     DatabaseHelper db = DatabaseHelper();
//                                                             //     var result = await db.getAllEpisdoesFromTable();
//                                                             //     for (int x = 0; x < result.length; x++) {
//                                                             //       print("Printinging new podcastEpisode");
//                                                             //       PodcastEpisode ep = PodcastEpisode.fromMapObject(result[x]);
//                                                             //       print(ep.toString());
//                                                             //     }
//                                                             //   },
//                                                             // ),
//                                                             // RaisedButton(child: Text("open test screen"),color: Colors.red,
//                                                             //   onPressed: () {
//                                                             //     Navigator.of(context).pushNamed(MainTestScreen.route);
//                                                             //   },
//                                                             // ),
//               PopularPodcastList()

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
