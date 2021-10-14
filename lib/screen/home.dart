import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ysi/models/project.dart';

import 'package:ysi/network_utils/api.dart';
import 'package:ysi/screen/editProject.dart';
import 'package:ysi/screen/login.dart';
import 'package:ysi/services/projectSerivce.dart';
import 'package:ysi/services/sharedPref.dart';
import 'package:ysi/widgets/styles.dart';
import 'package:ysi/widgets/spinkit.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';
  List<Project?>? projects;
  bool isInit = true;

  @override
  void initState() {
    _loadProjectData();
    super.initState();
  }

  _loadProjectData() async {
    setState(() {
      isInit = true;
    });
    var projectsData = await ProjectService().getAllProjects();
    if (projectsData['success']) {
      setState(() {
        projects = projectsData['projects'];
      });
    } else {
      setState(() {
        projects = [];
      });
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('YSI'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProject()),
              ).then((value) async {
                _loadProjectData();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              _loadProjectData();
            },
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: lightBrown,
      //   child: Icon(
      //     Icons.add,
      //     color: whiteSmoke,
      //   ),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => EditProject()),
      //     );
      //   },
      // ),
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
      body: isInit
          ? spinkit
          : RefreshIndicator(
              color: Colors.white,
              onRefresh: () async {
                _loadProjectData();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text(
                        '最新的專案',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (projects!.isEmpty)
                      Center(child: Text('目前沒有專案'))
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.start,
                        children: projects!
                            .map((item) => projectCard(item!))
                            .toList(),
                      ),
                  ],
                ),
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

  Widget projectCard(Project item) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              secondary: blueGrey,
              primary: lightBrown,
            ),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'googlesan',
            ),
        primaryTextTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'googlesan',
            ),
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('data'),
              Card(
                color: Colors.white,
                elevation: 16,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                margin:
                    EdgeInsets.only(bottom: 16, top: 8, left: 12, right: 12),
                child: Container(
                  // alignment: Alignment.center,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProject(
                                      project: item,
                                    )),
                          ).then((value) async {
                            _loadProjectData();
                          });
                        },
                        title: Text(item.name),
                        subtitle: Text(item.company!.name!),
                        leading: Icon(
                          Icons.receipt_long,
                        ),
                        trailing: Icon(Icons.chevron_right),
                      ),
                      Divider(),
                      Text(
                        '專案期間: ' +
                            DateFormat('yyyy-MM-dd').format(item.start!) +
                            ' - ' +
                            DateFormat("MM/dd").format(item.end!),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
