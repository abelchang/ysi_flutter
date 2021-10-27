import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ysi/models/project.dart';

import 'package:ysi/network_utils/api.dart';
import 'package:ysi/screen/editProject.dart';
import 'package:ysi/screen/login.dart';
import 'package:ysi/screen/sample.dart';
import 'package:ysi/screen/sysAnswers.dart';
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
    if (this.mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('YSI'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.umbrella),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ExampleTwo()),
          //     );
          //   },
          // ),
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
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 1600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
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
        constraints: BoxConstraints(maxWidth: 360),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '期間: ' +
                  DateFormat('yyyy/MM/dd').format(item.start!) +
                  ' - ' +
                  DateFormat("MM/dd").format(item.end!),
            ),
            Card(
              color: whiteSmoke,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              margin: EdgeInsets.only(bottom: 16, top: 8, left: 12, right: 12),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: lightBrown, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      minLeadingWidth: 16,
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
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '問卷:  ${item.qa?.name ?? '尚未建立'}',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ...item.linkcodes!.map((e) => Row(
                                children: [
                                  Text('分卷：${e.name}'),
                                  SizedBox(
                                    width: 64,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            '${e.done}',
                                            style: TextStyle(
                                              color: (e.done! > e.count!)
                                                  ? Colors.red[700]
                                                      ?.withOpacity(.6)
                                                  : Colors.black
                                                      .withOpacity(0.6),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            ' / ${e.count}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    (item.linkcodes!.isEmpty)
                        ? SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(right: 16.0, top: 8),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                child: Text('分析'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SysAnswers(
                                              project: item,
                                            )),
                                  );
                                },
                              ),
                            ),
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
    );
  }
}
