import 'package:flutter/material.dart';
import 'package:podcast_app/models/structures/constants.dart';
import '../../models/managers/database_helper.dart';
import '../../models/structures/podcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../../screens/podcast_details_screen.dart';
import 'package:marquee/marquee.dart';



class PodDetailsWithImage extends StatelessWidget {
    final Podcast podcast;
  final String imageUrl;
  final bool isSubbed = true;
  const PodDetailsWithImage({@required this.podcast, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    print("Author name is ${podcast.podcastAuthor}");
    return Container(
      color: buttonBackgroundColor,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(PodcastDetailsScreen.route, arguments: podcast);
        },
        highlightColor: Colors.red,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: podcast.podcastImageUrl,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: podcast.podcastTitle.length < 24
                          ? Padding(
                            padding: EdgeInsets.only(top: 10),
                              child: Text(
                              podcast.podcastTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 20),
                            ))
                          : Marquee(
                              velocity: 30,
                              text: podcast.podcastTitle,
                              blankSpace: 30,
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(fontSize: 20),
                            ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: podcast.podcastAuthor.length < 37
                          ? Text(
                              "   ${podcast.podcastAuthor}",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(fontSize: 16),
                            )
                          : Marquee(
                              text: podcast.podcastAuthor,
                              blankSpace: 150,
                              velocity: 30,
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class PodDetailsWithImage extends StatefulWidget {
//   final Podcast podcast;
//   final String imageUrl;
//   final bool isSubbed = true;
//   PodDetailsWithImage({@required this.podcast, this.imageUrl});

//   @override
//   _PodDisplayState createState() => _PodDisplayState();
// }

// class _PodDisplayState extends State<PodDetailsWithImage> {
//   DatabaseHelper db = DatabaseHelper();

//   @override
//   Widget build(BuildContext context) {
//     print("Author name is ${widget.podcast.podcastAuthor}");
//     return Container(
//       color: buttonBackgroundColor,
//       width: MediaQuery.of(context).size.width,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context)
//               .pushNamed(PodcastDetailsScreen.route, arguments: widget.podcast);
//         },
//         highlightColor: Colors.red,
//         child: Row(
//           children: <Widget>[
//             Flexible(
//               flex: 1,
//               fit: FlexFit.tight,
//               child: Padding(
//                 padding: EdgeInsets.only(left: 4),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(15),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: widget.podcast.podcastImageUrl,
//                     placeholder: (context, url) =>
//                         new CircularProgressIndicator(),
//                   ),
//                 ),
//               ),
//             ),
//             Flexible(
//               flex: 3,
//               fit: FlexFit.tight,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Flexible(
//                       flex: 1,
//                       fit: FlexFit.tight,
//                       child: widget.podcast.podcastTitle.length < 24
//                           ? Padding(
//                             padding: EdgeInsets.only(top: 10),
//                               child: Text(
//                               widget.podcast.podcastTitle,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .body1
//                                   .copyWith(fontSize: 20),
//                             ))
//                           : Marquee(
//                               velocity: 30,
//                               text: widget.podcast.podcastTitle,
//                               blankSpace: 30,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .body1
//                                   .copyWith(fontSize: 20),
//                             ),
//                     ),
//                     Flexible(
//                       flex: 1,
//                       fit: FlexFit.tight,
//                       child: widget.podcast.podcastAuthor.length < 37
//                           ? Text(
//                               "   ${widget.podcast.podcastAuthor}",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .body2
//                                   .copyWith(fontSize: 16),
//                             )
//                           : Marquee(
//                               text: widget.podcast.podcastAuthor,
//                               blankSpace: 150,
//                               velocity: 30,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .body2
//                                   .copyWith(fontSize: 16),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
