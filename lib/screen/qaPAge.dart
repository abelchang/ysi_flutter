import 'package:flutter/cupertino.dart';

class Qapage extends StatefulWidget {
  final code;
  const Qapage({Key? key, this.code}) : super(key: key);

  @override
  _QapageState createState() => _QapageState();
}

class _QapageState extends State<Qapage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(widget.code)),
    );
  }
}
