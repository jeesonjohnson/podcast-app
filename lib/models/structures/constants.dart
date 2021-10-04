import 'package:flutter/material.dart';

const double bigPodWidthScale = 0.4;
const double bigPodHeightScale = 0.6;
const double normalPodWidthScale = 0.4;
const double normalPodHeightScale = 0.6;
final String podcastAppName = "podcastapp";

const double appBarSize = 32;

const secondaryBackgroundColorTestHex = 0xFF363636;
const Color secondaryBackgroundColorTest = const MaterialColor(
  buttonBackgroundHex,
  const <int, Color>{
    50: const Color(secondaryBackgroundColorTestHex),
    100: const Color(secondaryBackgroundColorTestHex),
    200: const Color(secondaryBackgroundColorTestHex),
    300: const Color(secondaryBackgroundColorTestHex),
    400: const Color(secondaryBackgroundColorTestHex),
    500: const Color(secondaryBackgroundColorTestHex),
    600: const Color(secondaryBackgroundColorTestHex),
    700: const Color(secondaryBackgroundColorTestHex),
    800: const Color(secondaryBackgroundColorTestHex),
    900: const Color(secondaryBackgroundColorTestHex),
  },
);

const Color modalMusicPlayerColor = const MaterialColor(
  buttonBackgroundHex,
  const <int, Color>{
    50: const Color(buttonBackgroundHex),
    100: const Color(buttonBackgroundHex),
    200: const Color(buttonBackgroundHex),
    300: const Color(buttonBackgroundHex),
    400: const Color(buttonBackgroundHex),
    500: const Color(buttonBackgroundHex),
    600: const Color(buttonBackgroundHex),
    700: const Color(buttonBackgroundHex),
    800: const Color(buttonBackgroundHex),
    900: const Color(buttonBackgroundHex),
  },
);

const primaryBlackHex = 0xFF181818; //Original colour choice
const primaryBlackHexTest = 0xFF000000;
const MaterialColor primaryColorBlackBG = const MaterialColor(
  primaryBlackHexTest,
  const <int, Color>{
    50: const Color(primaryBlackHexTest),
    100: const Color(primaryBlackHexTest),
    200: const Color(primaryBlackHexTest),
    300: const Color(primaryBlackHexTest),
    400: const Color(primaryBlackHexTest),
    500: const Color(primaryBlackHexTest),
    600: const Color(primaryBlackHexTest),
    700: const Color(primaryBlackHexTest),
    800: const Color(primaryBlackHexTest),
    900: const Color(primaryBlackHexTest),
  },
);
const accentColorHex = 0xFFdd6161;
const MaterialColor accentColorRed = const MaterialColor(
  accentColorHex,
  const <int, Color>{
    50: const Color(accentColorHex),
    100: const Color(accentColorHex),
    200: const Color(accentColorHex),
    300: const Color(accentColorHex),
    400: const Color(accentColorHex),
    500: const Color(accentColorHex),
    600: const Color(accentColorHex),
    700: const Color(accentColorHex),
    800: const Color(accentColorHex),
    900: const Color(accentColorHex),
  },
);

const textColorGreenHex = 0xFF3cc28f;
const MaterialColor textColorGreen = const MaterialColor(
  textColorGreenHex,
  const <int, Color>{
    50: const Color(textColorGreenHex),
    100: const Color(textColorGreenHex),
    200: const Color(textColorGreenHex),
    300: const Color(textColorGreenHex),
    400: const Color(textColorGreenHex),
    500: const Color(textColorGreenHex),
    600: const Color(textColorGreenHex),
    700: const Color(textColorGreenHex),
    800: const Color(textColorGreenHex),
    900: const Color(textColorGreenHex),
  },
);

const buttonBackgroundHex =
    0xFF121111; //0xFF0d0d0c;//Original hex value was 0xFF616161

const MaterialColor buttonBackgroundColor = const MaterialColor(
  buttonBackgroundHex,
  const <int, Color>{
    50: const Color(buttonBackgroundHex),
    100: const Color(buttonBackgroundHex),
    200: const Color(buttonBackgroundHex),
    300: const Color(buttonBackgroundHex),
    400: const Color(buttonBackgroundHex),
    500: const Color(buttonBackgroundHex),
    600: const Color(buttonBackgroundHex),
    700: const Color(buttonBackgroundHex),
    800: const Color(buttonBackgroundHex),
    900: const Color(buttonBackgroundHex),
  },
);

const textColorHex = 0xFFe0e0e0;
const MaterialColor textColor = const MaterialColor(
  textColorHex,
  const <int, Color>{
    50: const Color(textColorHex),
    100: const Color(textColorHex),
    200: const Color(textColorHex),
    300: const Color(textColorHex),
    400: const Color(textColorHex),
    500: const Color(textColorHex),
    600: const Color(textColorHex),
    700: const Color(textColorHex),
    800: const Color(textColorHex),
    900: const Color(textColorHex),
  },
);

const unselecteTextHex = 0xFFd3d0d0;
const MaterialColor unselectedTextColor = const MaterialColor(
  unselecteTextHex,
  const <int, Color>{
    50: const Color(unselecteTextHex),
    100: const Color(unselecteTextHex),
    200: const Color(unselecteTextHex),
    300: const Color(unselecteTextHex),
    400: const Color(unselecteTextHex),
    500: const Color(unselecteTextHex),
    600: const Color(unselecteTextHex),
    700: const Color(unselecteTextHex),
    800: const Color(unselecteTextHex),
    900: const Color(unselecteTextHex),
  },
);

String numberOfMonth(String monthString) {
  switch (monthString) {
    case "Jan":
      return "01";
    case "Feb":
      return "02";
    case "Mar":
      return "03";
    case "Apr":
      return "04";
    case "May":
      return "05";
    case "Jun":
      return "06";
    case "Jul":
      return "07";
    case "Aug":
      return "08";
    case "Sep":
      return "09";
    case "Oct":
      return "10";
    case "Nov":
      return "11";
    case "Dec":
      return "12";
    default:
      return "01";
  }
}

DateTime getFormatedDateTimeRSS(String date) {
  try {
    var data = date.split(" ");
    var dateTime = DateTime.parse(
        "${data[3]}-${numberOfMonth(data[2])}-${data[1]} ${data[4]}");

    //print("episode datetitme is ${dateTime.toIso8601String()}");
    return dateTime;
  } catch (e) {
    return DateTime.now();
  }
}

String dateTimeToString(DateTime dateTime) {
  String typeOfDay = "PM";
  String hour;
  String minute;

  if (dateTime.hour < 12) {
    typeOfDay = "AM";
  }
  if (dateTime.hour < 10) {
    hour = "0" + dateTime.hour.toString();
  } else if (dateTime.hour > 12) {
    hour = (dateTime.hour - 12).toString();
  } else {
    hour = dateTime.hour.toString();
  }
  if (dateTime.minute < 10) {
    minute = "0${dateTime.minute.toString()}";
  } else {
    minute = "${dateTime.minute.toString()}";
  }



  return "${dateTime.day}-${dateTime.month}-${dateTime.year}  $hour:$minute $typeOfDay";
}
