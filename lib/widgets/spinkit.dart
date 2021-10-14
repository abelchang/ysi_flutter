import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final spinkit = SpinKitChasingDots(
  color: Colors.white,
);

Widget circlekit(String text) {
  return Row(
    children: [
      Text(text),
      SpinKitThreeBounce(
        color: Colors.white,
        size: 22,
      ),
    ],
  );
}
