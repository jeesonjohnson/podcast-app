import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

void main() async {
  var initialTime=DateTime.now().second;
  print("Startuibg");
  http.Response result=await http.head("http://traffic.libsyn.com/joeroganexp/p1355.mp3?dest-id=19997");
  //http.read("url");
  print(result.url);
  var finalTime=DateTime.now().second;
  print("Finished${finalTime-initialTime}");
}
// import '../models/constants.dart';
// String numberOfMonth(String monthString) {
//   switch (monthString) {
//     case "Jan":
//       return "01";
//     case "Feb":
//       return "02";
//     case "Mar":
//       return "03";
//     case "Apr":
//       return "04";
//     case "May":
//       return "05";
//     case "Jun":
//       return "06";
//     case "Jul":
//       return "07";
//     case "Aug":
//       return "08";
//     case "Sep":
//       return "09";
//     case "Oct":
//       return "10";
//     case "Nov":
//       return "11";
//     case "Dec":
//       return "12";
//     default:
//       return "01";
//   }
// }
// //Tue, 27 Aug 2019 02:54:06 +0000

// DateTime getFormatedDateTimeRSS(String date) {
//   var data = date.split(" ");
//   return DateTime.parse(
//       "${data[3]}-${numberOfMonth(data[2])}-${data[1]} ${data[4]}");
// }

// void main() {
//   print("Starting program");

//   var client = new http.Client();
//   String url = "https://www.theverge.com/rss/index.xml";
//   var body;
//   try {
//     client.get(url).then((response) {
//       body = response.body;    
//       return response.body;
//     }).then((bodyString) {
//       print("Using Rss Feeder");
//       var channel = new RssFeed.parse(bodyString);
//       print(channel.title);
//       return "RssFeed";
//     }).catchError((onError){
//       var feed = new AtomFeed.parse(body);
//     print(feed.items[0].title);
//     });

//   } catch (e) {
//     print("Using AtomFeed Reader");
//     var feed = new AtomFeed.parse(body);
//     print(feed.items[0].title);

//     // print("Nope");
//     // client.get(url).then((response) {
//     //   return response.body;
//     // }).then((bodyString) {
//     //   print("Using AtomFeed Reader");
//     //   var feed = new AtomFeed.parse(bodyString);
//     //   print(feed.items[0].title);
//     //   return feed;
//     // });

//   }

//   client.close();

// //MAIN DATAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
//   // // RSS feed
//   // client.get("https://developer.apple.com/news/releases/rss/releases.rss").then((response) {
//   //   return response.body;
//   // }).then((bodyString) {
//   //   var channel = new RssFeed.parse(bodyString);
//   //   print(channel.items[0]);
//   //   return channel;
//   // });

//   // // Atom feed
//   //var client=new http.Client();
//   // client.get("https://www.theverge.com/rss/index.xml").then((response) {
//   //   return response.body;
//   // }).then((bodyString) {
//   //   var feed = new AtomFeed.parse(bodyString);
//   //   print(feed);
//   //   return feed;
//   // });
//   //cleint.close()

//   print("Program finished");
// }
