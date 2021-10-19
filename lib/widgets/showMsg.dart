import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ysi/widgets/styles.dart';

void showMsg(msg, context) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        // Some code to undo the change!
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Timer? _timer;
Future<String?> showDialogMgs(BuildContext context, String mgs) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      _timer = Timer(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ThemeData.light().colorScheme.copyWith(
                secondary: blueGrey,
                primary: lightBrown,
              ),
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'googlesan',
              ),
          primaryTextTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'googlesan',
              ),
        ),
        child: AlertDialog(
          backgroundColor: darkBlueGrey3,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          // title: Text(
          //   '訊息提示',
          // ),
          content: Text(mgs),
        ),
      );
    },
  ).then((val) {
    if (_timer!.isActive) {
      _timer!.cancel();
    }
  });
}
