import 'package:flutter/material.dart';

import 'package:ysi/network_utils/api.dart';
import 'package:ysi/screen/editProject.dart';
import 'package:ysi/screen/login.dart';
import 'package:ysi/services/projectSerivce.dart';
import 'package:ysi/services/sharedPref.dart';
import 'package:ysi/widgets/styles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    ProjectService().getAllComapnies();
    var user = await SharedPref().getUser();
    if (user != null) {
      setState(() {
        name = user.name ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YSI'),
        backgroundColor: darkBlueGrey3,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: pinkLite,
        child: Icon(
          Icons.add,
          color: whiteSmoke,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProject()),
          );
        },
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          shrinkWrap: true,
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: blueGrey,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            FractionallySizedBox(
              widthFactor: .4,
              child: ElevatedButton(
                onPressed: () {
                  logout();
                },
                // style: ElevatedButton.styleFrom(
                //   // primary: Color(0xFF1877F2),
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10))),
                // ),
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hi, $name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Center(
              child: Text(
                'Hi, $name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    var body = await Network().getData('/logout');

    if (body['success']) {
      SharedPref().removeUserData();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
