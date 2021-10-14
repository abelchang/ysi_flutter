// import 'dart:developer';

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ysi/models/company.dart';
import 'package:ysi/models/project.dart';
import 'package:ysi/screen/editQa.dart';
import 'package:ysi/services/projectSerivce.dart';
import 'package:ysi/widgets/styles.dart';
import 'package:intl/intl.dart';

class EditProject extends StatefulWidget {
  final Project? project;
  EditProject({Key? key, this.project}) : super(key: key);

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();
  Project? project;
  TextEditingController _selectionStartController = TextEditingController();
  TextEditingController _selectionEndController = TextEditingController();
  List<Company?> companies = [];
  List<String>? companiesData = [];
  bool isLoading = false;
  bool isEdit = false;
  bool isNew = true;

  void initState() {
    iniProject();
    super.initState();
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _selectionStartController.dispose();
    _selectionEndController.dispose();
  }

  iniProject() async {
    if (widget.project == null) {
      project = Project(id: -1, name: '', company: Company(name: ''));
      setState(() {
        isEdit = true;
      });
    } else {
      project = widget.project;
      _selectionStartController.text =
          DateFormat('yyy/MM/dd').format(project!.start!).toString();
      _selectionEndController.text =
          DateFormat('yyy/MM/dd').format(project!.end!).toString();
      isNew = false;
    }
    var res = await ProjectService().getAllComapnies();

    if (res['success'] == true) {
      print('get comapnies success');
      companies = res['companies'];
      setState(() {
        companiesData = companies.map((e) {
          return e?.name ?? '';
        }).toList();
      });
    }
  }

  unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  editButton() {
    return !isEdit
        ? ElevatedButton(
            onPressed: () {
              setState(() {
                isEdit = true;
              });
            },
            child: Text('編輯'),
          )
        : ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });

                var result = await ProjectService().createProject(project!);
                setState(() {
                  if (result['success']) {
                    project = result['project'];
                    debugPrint('res project success:' + jsonEncode(project));
                  }
                  isLoading = false;
                  isEdit = false;
                  isNew = false;
                });
              } else {
                return;
              }
            },
            child: Text(
              '儲存',
            ),
          );
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

  createQAForm() {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          '問卷資料',
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(
          height: 8,
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
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditQA(
                              project: project!,
                            )),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        project = value;
                      });
                    }
                  });
                },
                title: Text("問卷"),
                subtitle: (project?.qa == null)
                    ? Text("目前沒有問卷")
                    : Text(project?.qa?.name ?? ''),
                leading: Icon(
                  Icons.receipt_long,
                ),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
      ],
    );
  }

  createProjectForm() {
    return Form(
      key: _formKey,
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
            '須先建立專案的基本資料',
            style: TextStyle(fontSize: 14, color: Colors.white54),
          ),
          Text(
            '才能新增問卷內容喔',
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
                        initialValue: project!.name,
                        scrollPadding: EdgeInsets.all(90),
                        enabled: isEdit,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.red.shade200),
                          prefixIcon: Icon(
                            Icons.apartment,
                          ),
                          hintText: "專案名稱",
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
                          project?.name = value;
                        },
                      ),
                      GestureDetector(
                        onTap: !isEdit
                            ? null
                            : () async {
                                var date = await _showDatePicker();
                                if (date != null) {
                                  setState(() {
                                    project?.start = date!;
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
                            enabled: isEdit,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                        onTap: !isEdit
                            ? null
                            : () async {
                                var date = await _showDatePicker();
                                if (date != null) {
                                  setState(() {
                                    project!.end = date;
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
                            enabled: isEdit,
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
                              if (project!.start != null) {
                                if (project!.end!.isBefore(project!.start!)) {
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
                              mode: Mode.BOTTOM_SHEET,
                              enabled: isEdit,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // mode: Mode.BOTTOM_SHEET,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '請輸入輔導公司';
                                } else
                                  return null;
                              },
                              key: _openDropDownProgKey,
                              items: companiesData,
                              label: "輔導的公司",
                              onChanged: !isEdit
                                  ? null
                                  : (data) {
                                      if (data != null) {
                                        debugPrint('data:$data');
                                        project!.company!.name = data;
                                        project!.company!.id = -1;
                                      }
                                    },
                              selectedItem: project!.company?.name,
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
                              // dropdownBuilder: (context, selectedItems) {
                              //   if (selectedItems!.isEmpty) {
                              //     return ListTile(
                              //       contentPadding: EdgeInsets.all(0),
                              //       leading: CircleAvatar(),
                              //       title: Text("尚未選擇"),
                              //     );
                              //   } else {
                              //     return Text(selectedItems);
                              //   }
                              // },
                              // popupItemBuilder: (BuildContext context,
                              //     String? item, bool isSelected) {
                              //   return Container(
                              //       margin: EdgeInsets.symmetric(horizontal: 8),
                              //       decoration: !isSelected
                              //           ? null
                              //           : BoxDecoration(
                              //               border: Border.all(
                              //                   color: Theme.of(context)
                              //                       .primaryColor),
                              //               borderRadius:
                              //                   BorderRadius.circular(5),
                              //               color: Colors.white,
                              //             ),
                              //       child: Center(
                              //         child: Text(
                              //           item ?? '',
                              //           style: TextStyle(fontSize: 18),
                              //         ),
                              //       ));
                              // },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: !isEdit
                                ? null
                                : () async {
                                    var data = await inputDialog(context);
                                    if (data != null && data.isNotEmpty) {
                                      _openDropDownProgKey.currentState
                                          ?.changeSelectedItem(data);
                                      project!.company!.name = data;
                                      project!.company!.id = null;
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
                        height: 32,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 32.0),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : editButton(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('專案'),
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
              isNew
                  ? SizedBox(
                      width: 0,
                    )
                  : createQAForm(),
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
