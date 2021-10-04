//Dart Imports

//Flutter imports
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
//import 'package:image_downloader/image_downloader.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'dart:io' as Io;
//import 'package:simple_permissions/simple_permissions.dart';
//File Imports
import '../models/structures/constants.dart';
import '../components/pod/pod_display.dart';
import '../widgets/pod_list.dart';



class TestScreen extends StatefulWidget {
  TestScreen({Key key}) : super(key: key);

  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        FlatButton(
          child: Text("Load offlineImage"),
          onPressed: () {
            print("Loading offline Image");
            imageDownloader(
                "http://static.libsyn.com/p/assets/7/1/f/3/71f3014e14ef2722/JREiTunesImage2.jpg");

          },
        ),
        imagePath == null ? Text("No Image Loaded Yet") : Image.asset(imagePath)
      ],
    ));
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
          .download(
        imageUrl,
        "${dir.path.toString()}/$uniqueImageNumber",
      )
          .then((onValue) {
        finalImageLink = "${dir.path.toString()}/$uniqueImageNumber";

      });
    } catch (e) {
      print(e.toString());
      print("Image Getting Failed");
    }
    print("Genereated image link is found at: $finalImageLink");

    setState(() {
     this.imagePath=finalImageLink; 
    });


    return finalImageLink;
  }


  // Future<String> olderimageDownloader(String imageUrl) async {
  //   Dio dio = Dio();
  //   try {
      
  //     var dir = await getApplicationDocumentsDirectory();
  //     dir =
  //       await new Io.Directory('${dir.path}/images').create(recursive: true);
  //     await dio
  //         .download(imageUrl,"${dir.path.toString()}/maxresdefault",)
  //         .then((onValue) {
  //                     print("Download compelted now setting path");
  //                     print("Compelted at path ${dir.path.toString()}");
  //       setState(() {
  //         imagePath = dir.path + "/maxresdefault";
  //       });
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     print("Gettings failed");
  //   }

  //   return "Complted";
  // }




// //THIS DOES NTO WORK CURRENTLY BUT YOU NEED TO MAKE WORK
//   Future<bool> downloadImage(String url) async {
//      await new Future.delayed(new Duration(seconds: 1));
//   bool checkResult =
//       await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
//   if (!checkResult) {
//     var status = await SimplePermissions.requestPermission(
//         Permission.WriteExternalStorage);
//     if (status == PermissionStatus.authorized) {
//       var res = await imageDownloader(url);
//       return res != null;
//     }
//   } else {
//     var res = await imageDownloader(url);
//     return res != null;
//   }
//   return false;
// }

// Future<Io.File> saveImage(String url) async {
//   try {
//     final file = await getImageFromNetwork(url);
//     var dir = await getExternalStorageDirectory();
//     var testdir =
//         await new Io.Directory('${dir.path}/iLearn').create(recursive: true);
//     IM.Image image = IM.decodeImage(file.readAsBytesSync());
//     return new Io.File(
//         '${testdir.path}/${DateTime.now().toUtc().toIso8601String()}.png')
//       ..writeAsBytesSync(IM.encodePng(image));
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }



  // Future<String> loadOfflineImage(String imageUrl) async {
  //   String imageName = "Main2";
  //   var pathGenerated = await ImageDownloader.downloadImage(
  //     imageUrl,
  //     destination: AndroidDestinationType.custom(
  //         directory: "$podcastAppName",
  //         subDirectory: "podcast_images/$imageName",
  //         inPublicDir: false),
  //   );

  //   var filePath = await ImageDownloader.findPath(pathGenerated).then((path) {
  //     return path;
  //   });
  //   setState(() {
  //     imagePath = filePath;
  //   });

  //   return filePath;
  // }


  /*OLD WORKING IMAGE LOADER

    void loadOffflineImage(String imageUrl) async {
      try{
        var number = Random().nextInt(999999999);
      String imageName =
          "${number.toString()}${(number * 2).toString()}${(number * 3).toString()}";

      var pathGenerated = await ImageDownloader.downloadImage(
        imageUrl,
        destination: AndroidDestinationType.custom(
            directory: "$podcastAppName",
            subDirectory: "podcast_images/$imageName",
            inPublicDir: true),
      );

      this.localPodcastImageUrl =
          await ImageDownloader.findPath(pathGenerated).then((path) {
        return path;
      });
      }catch(e){
        this.localPodcastImageUrl="assets/images/error.jpg";
      }
    }
  */
}
