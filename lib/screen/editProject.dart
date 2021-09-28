import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ysi/models/company.dart';
import 'package:ysi/models/project.dart';
import 'package:ysi/services/sharedPref.dart';
import 'package:ysi/widgets/styles.dart';
import 'package:intl/intl.dart';

class EditProject extends StatefulWidget {
  const EditProject({Key? key}) : super(key: key);

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();
  Project project = Project(name: '');
  TextEditingController _selectionStartController = TextEditingController();
  TextEditingController _selectionEndController = TextEditingController();
  List<Company?> companies = [];
  List<String>? companiesData = ['1', '1', '1'];

  void initState() {
    super.initState();
    iniProject();
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _selectionStartController.dispose();
    _selectionEndController.dispose();
  }

  iniProject() async {
    companies = await SharedPref().getAllCompanies();
    setState(() {
      companiesData = companies.map((e) {
        return e?.name ?? '';
      }).toList();
      inspect(companiesData);
    });

    // _selectionStartController.text =
    //     DateFormat('yyy/MM/dd').format(DateTime.now()).toString();
  }

  unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  Future _showDatePicker() async {
    var date = await showDatePicker(
      context: context,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light().copyWith(
            primary: lightBrown,
          ),
          textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'googlesan',
              ),
          primaryTextTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'googlesan',
              ),
        ),
        child: child!,
      ),
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2080),
    );
    return date;
  }

  createProjectForm() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 16,
          ),
          Text(
            '專案資料',
            style: TextStyle(fontSize: 22),
          ),
          Text(
            '...........................',
            style: TextStyle(fontSize: 14, color: Colors.white54),
          ),
          Text(
            '........................................',
            style: TextStyle(fontSize: 14, color: Colors.white54),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 640),
            child: Theme(
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
              child: Card(
                color: whiteSmoke,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                margin: EdgeInsets.only(bottom: 16, top: 8, left: 8, right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        scrollPadding: EdgeInsets.all(90),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // controller: _nameController,
                        // focusNode: _focusName,

                        // cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.red.shade200),
                          prefixIcon: Icon(
                            Icons.apartment,
                          ),
                          // labelText: "* 客人姓名 必填項目",
                          hintText: "專案名稱",
                          errorStyle: TextStyle(color: Colors.red.shade200),
                        ),
                        onEditingComplete: () {
                          unfocus();
                        },
                        onTap: () {
                          // _focuserr = null;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '請輸入專案名稱';
                          }
                          project.name = value;
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          var date = await _showDatePicker();
                          if (date != null) {
                            setState(() {
                              project.start = date!;
                              _selectionStartController.text =
                                  DateFormat('yyy/MM/dd')
                                      .format(date!)
                                      .toString();
                            });
                          }

                          unfocus();
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _selectionStartController,
                            // cursorColor: Colors.grey,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                // color: Colors.white,
                              ),
                              labelText: "問卷開始日期",
                              hintText: "問卷開始日期",
                              // icon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '請輸入問卷開始日期';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var date = await _showDatePicker();
                          if (date != null) {
                            setState(() {
                              project.end = date;
                              _selectionEndController.text =
                                  DateFormat('yyy/MM/dd')
                                      .format(date)
                                      .toString();
                            });
                          }

                          unfocus();
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _selectionEndController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            // cursorColor: Colors.grey,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                // color: Colors.white,
                              ),
                              labelText: "問卷結束日期",
                              hintText: "問卷結束日期",
                              // icon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '請輸入問卷結束日期';
                              }
                              if (project.start != null) {
                                if (project.end!.isBefore(project.start!)) {
                                  return "問卷結束日期不能早於問卷開始日期";
                                }
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),

                      ///BottomSheet Mode with no searchBox
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: DropdownSearch<String>(
                              // dropdownSearchDecoration: InputDecoration(
                              //   border: UnderlineInputBorder(
                              //       // borderSide: BorderSide(color: Color(0xFF01689A)),
                              //       ),
                              // ),
                              mode: Mode.BOTTOM_SHEET,
                              key: _openDropDownProgKey,
                              items: companiesData,
                              label: "輔導的公司",
                              onChanged: (data) {
                                if (data != null) {
                                  project.conpany?.name = data;
                                }
                              },
                              selectedItem: project.conpany?.name,
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12, 12, 8, 0),
                                  labelText: "搜尋輔導公司",
                                ),
                              ),
                              popupTitle: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: darkBlueGrey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 640),
                                  child: Center(
                                    child: Text(
                                      '輔導的公司',
                                      style: TextStyle(
                                        fontSize: 24,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              popupShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var data = await inputDialog(context);
                              if (data != null && data.isNotEmpty) {
                                _openDropDownProgKey.currentState
                                    ?.changeSelectedItem(data);
                                project.conpany?.name = data;
                                companiesData!.insert(0, data);
                              }
                            },
                            child: Icon(Icons.add, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(8),
                              // primary: Colors.blue, // <-- Button color
                              // onPrimary: Colors.red, // <-- Splash color
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      key: _formKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新增專案'),
        backgroundColor: darkBlueGrey3,
      ),
      body: GestureDetector(
        onTap: unfocus,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: ListView(
            controller: _scrollController,
            children: [
              createProjectForm(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> inputDialog(BuildContext context) async {
  String inputData = '';
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
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
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          title: Text(
            '新公司名稱',
            // style: TextStyle(color: Colors.black87),
          ),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '公司名稱',
                  hintText: '請輸入...',
                ),
                onChanged: (value) {
                  inputData = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('送出'),
              onPressed: () {
                Navigator.of(context).pop(inputData);
              },
            ),
          ],
        ),
      );
    },
  );
}
