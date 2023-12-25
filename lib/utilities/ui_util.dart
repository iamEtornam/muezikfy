
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

alertNotification(
    {required String message,
      required BuildContext context,
      int duration = 3}) {
  return BotToast.showSimpleNotification(
      duration: Duration(seconds: duration),
      title: message,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: 10,
      align: Alignment.topCenter);
}

 String parseToMinutesSeconds(int ms) {
String data;
Duration duration = Duration(milliseconds: ms);

int minutes = duration.inMinutes;
int seconds = (duration.inSeconds) - (minutes * 60);

data = minutes.toString() + ":";
if (seconds <= 9) data += "0";

data += seconds.round().toString();
return data;
}