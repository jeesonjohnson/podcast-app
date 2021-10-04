import 'package:flutter/material.dart';
import '../../models/managers/database_helper.dart';
import '../../models/structures/podcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../../screens/podcast_details_screen.dart';

class PodDisplay extends StatefulWidget {
  final Podcast podcast;
  final String imageUrl;
  final bool isSubbed=true;
  PodDisplay({@required this.podcast, this.imageUrl});
  

  @override
  _PodDisplayState createState() => _PodDisplayState();
}

class _PodDisplayState extends State<PodDisplay> {
  DatabaseHelper db=DatabaseHelper();

  @override
  Widget build(BuildContext context) {
      
    return Container(
      // decoration: BoxDecoration(color: Colors.black12, boxShadow: [
      //   BoxShadow(
      //     color: Colors.black12,
      //     offset: Offset(3.0, 6.0),
      //     blurRadius: 10.0,
      //   )
      // ]),
      height: 180,
      width: 182,
      padding: EdgeInsets.only(
        left: 11,
        right: 11,
      ),
      child: InkWell(
        onTap: () {
          
          Navigator.of(context)
              .pushNamed(PodcastDetailsScreen.route, arguments: widget.podcast);
        },
        highlightColor: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    child: widget.podcast.localPodcastImageUrl == null
                        ? CachedNetworkImage(
                            imageUrl: widget.podcast.podcastImageUrl,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                          )
                        : Image.file(
                            File(widget.podcast.localPodcastImageUrl),
                          ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.isSubbed ? (Icons.favorite) : (Icons.favorite_border),
                  ),
                  color: Colors.red,
                  onPressed: () async {
                    print("Starting inversion");
                    DatabaseHelper db = DatabaseHelper();
                    await db.invertPodcastSubscription(widget.podcast.itunesID);
                    setState(() {
                      //widget.isSubbed=widget.isSubbed ? "false" : "true";
                    });
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                )
              ],
            ),
            Text(
              widget.podcast.podcastTitle,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 14,
                  ),
            ),
          ],
        ),
        //splashColor: Colors.transparent,
        //highlightColor: Colors.transparent,
      ),
    );
  }


}
