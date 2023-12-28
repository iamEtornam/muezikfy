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
      borderRadius: 10.0,
      align: Alignment.topCenter);
}

String parseToMinutesSeconds(int ms) {
  String data;
  Duration duration = Duration(milliseconds: ms);

  int minutes = duration.inMinutes;
  int seconds = (duration.inSeconds) - (minutes * 60);

  data = "$minutes:";
  if (seconds <= 9) data += "0";

  data += seconds.round().toString();
  return data;
}

double calculateScaleValue(
    num originalValue, num originalScaleEnd, num targetScaleEnd) {
  // Ensure originalScaleEnd is not zero to avoid division by zero
  if (originalScaleEnd == 0) {
    originalScaleEnd = 100;
  }

  // Calculate the proportion factor
  double proportionFactor = targetScaleEnd / originalScaleEnd;

  // Apply the proportion to the original value
  double scaledValue = originalValue * proportionFactor;

  return scaledValue;
}

const defaultArtWork =
    'https://firebasestorage.googleapis.com/v0/b/freemindsgh.appspot.com/o/appstore.png?alt=media&token=ca94180a-56a3-410e-a7ab-335a6ee8ab8f';
