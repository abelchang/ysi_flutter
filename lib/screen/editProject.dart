// import 'dart:developer';

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ysi/models/company.dart';
import 'package:ysi/models/project.dart';
import 'package:ysi/screen/editQa.dart';
import 'package:ysi/screen/qaPAge.dart';
import 'package:ysi/services/projectSerivce.dart';
import 'package:ysi/widgets/showMsg.dart';
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
  final _projectFormKey = GlobalKey<FormState>();

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
    _scrollController.dispose();
    _selectionStartController.dispose();
    _selectionEndController.dispose();
    super.dispose();
  }

  iniProject() async {
    if (widget.project == null) {
      project =
          Project(id: -1, name: '', company: Company(name: ''), linkcodes: []);
      if (this.mounted) {
        setState(() {
          isEdit = true;
        });
      }
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
      if (this.mounted) {
        setState(() {
          companiesData = companies.map((e) {
            return e?.name ?? '';
          }).toList();
        });
      }
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
        ? FloatingActionButton(
            backgroundColor: lightBrown,
            onPressed: () {
              if (this.mounted) {
                setState(() {
                  isEdit = true;
                });
              }
            },
            child: Text('??????'),
          )
        : FloatingActionButton(
            backgroundColor: lightBrown,
            onPressed: () async {
              unfocus();
              if (_projectFormKey.currentState!.validate()) {
                if (this.mounted) {
                  setState(() {
                    isLoading = true;
                  });
                }

                var result = await ProjectService().createProject(project!);
                if (this.mounted) {
                  setState(() {
                    if (result['success']) {
                      project = result['project'];
                      debugPrint('res project success:' + jsonEncode(project));
                    }
                    isLoading = false;
                    isEdit = false;
                    isNew = false;
                  });
                }
              } else {
                return;
              }
            },
            child: Text(
              '??????',
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
          '????????????',
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
                      if (this.mounted) {
                        setState(() {
                          project = value;
                        });
                      }
                    }
                  });
                },
                title: Text("??????"),
                subtitle: (project?.qa == null)
                    ? Text("??????????????????")
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          '????????????',
          style: TextStyle(fontSize: 22),
        ),
        Text(
          '?????????????????????????????????',
          style: TextStyle(fontSize: 14, color: Colors.white54),
        ),
        Text(
          '???????????????????????????',
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
                        hintText: "????????????",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '?????????????????????';
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
                                if (this.mounted) {
                                  setState(() {
                                    project?.start = date!;
                                    _selectionStartController.text =
                                        DateFormat('yyy/MM/dd')
                                            .format(date!)
                                            .toString();
                                  });
                                }
                              }
                              unfocus();
                            },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _selectionStartController,
                          enabled: isEdit,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // cursorColor: Colors.grey,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              // color: Colors.white,
                            ),
                            labelText: "??????????????????",
                            hintText: "??????????????????",
                            // icon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '???????????????????????????';
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
                                if (this.mounted) {
                                  setState(() {
                                    project!.end = date;
                                    _selectionEndController.text =
                                        DateFormat('yyy/MM/dd')
                                            .format(date)
                                            .toString();
                                  });
                                }
                              }

                              unfocus();
                            },
                      child: AbsorbPointer(
                        child: TextFormField(
                          enabled: isEdit,
                          controller: _selectionEndController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // cursorColor: Colors.grey,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              // color: Colors.white,
                            ),
                            labelText: "??????????????????",
                            hintText: "??????????????????",
                            // icon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '???????????????????????????';
                            }
                            if (project!.start != null) {
                              if (project!.end!.isBefore(project!.start!)) {
                                return "????????????????????????????????????????????????";
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
                            mode: Mode.MENU,
                            enabled: isEdit,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            // mode: Mode.BOTTOM_SHEET,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '?????????????????????';
                              } else
                                return null;
                            },
                            key: _openDropDownProgKey,
                            items: companiesData,
                            label: "???????????????",
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
                                labelText: "??????????????????",
                              ),
                            ),
                            popupBackgroundColor: whiteSmoke,

                            // popupTitle: Container(
                            //   height: 50,
                            //   decoration: BoxDecoration(
                            //     color: darkBlueGrey,
                            //     borderRadius: BorderRadius.only(
                            //       topLeft: Radius.circular(20),
                            //       topRight: Radius.circular(20),
                            //     ),
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       '???????????????',
                            //       style: TextStyle(
                            //         fontSize: 24,
                            //         // fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // popupShape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.only(
                            //     topLeft: Radius.circular(24),
                            //     topRight: Radius.circular(24),
                            //   ),
                            // ),
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
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  createLinkCodes() {
    // debugPrint('createLinkCodes');
    // inspect(project);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          '????????????',
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ..._getLinkCodes(),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _getLinkCodes() {
    List<Widget> linkCodeTextFields = [];
    for (int i = 0; i < project!.linkcodes!.length; i++) {
      linkCodeTextFields.add(_linkCodeForm(i));
    }
    return linkCodeTextFields;
  }

  Widget _linkCodeForm(int i) {
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 8, bottom: 16, left: 4, right: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border(
                  top: BorderSide(color: lightBrown.withOpacity(.8), width: 4),
                ),
                // color: lightBrown,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  '??????${i + 1}',
                  // style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextFormField(
              initialValue: project!.linkcodes![i].name,
              scrollPadding: EdgeInsets.all(90),
              enabled: isEdit,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.receipt_long,
                ),
                labelText: "????????????",
              ),
              onTap: () {
                // _focuserr = null;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return '?????????????????????';
                }
                project!.linkcodes![i].name = value;
              },
            ),
            TextFormField(
              initialValue: project!.linkcodes![i].count.toString(),
              scrollPadding: EdgeInsets.all(90),
              enabled: isEdit,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.article,
                ),
                labelText: "????????????",
              ),
              onTap: () {
                // _focuserr = null;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return '?????????????????????';
                }
                project!.linkcodes![i].count = int.parse(value);
              },
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              initialValue: Uri.base.toString() + project!.linkcodes![i].code!,
              scrollPadding: EdgeInsets.all(90),
              readOnly: true,
              enableInteractiveSelection: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(),
                ),
                prefixIcon: Icon(
                  Icons.share,
                ),
                labelText: "????????????",
                suffixIcon: IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                            text: Uri.base.toString() +
                                project!.linkcodes![i].code!))
                        .whenComplete(() => showDialogMgs(context, '????????????????????????'));
                  },
                  icon: Icon(Icons.content_copy),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Qapage(
                          code: project!.linkcodes![i].code,
                          preview: true,
                        ),
                      ));
                },
                child: Text('??????'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('??????'),
      ),
      floatingActionButton: isLoading
          ? CircularProgressIndicator(
              color: lightBrown,
            )
          : editButton(),
      body: GestureDetector(
        onTap: unfocus,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: Form(
            key: _projectFormKey,
            child: ListView(
              controller: _scrollController,
              children: [
                createProjectForm(),
                isNew
                    ? SizedBox(
                        width: 0,
                      )
                    : createQAForm(),
                if (project?.linkcodes == null ||
                    project?.linkcodes!.length == 0)
                  SizedBox(
                    height: 0,
                  )
                else
                  createLinkCodes(),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
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
            '???????????????',
            // style: TextStyle(color: Colors.black87),
          ),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '????????????',
                  hintText: '?????????...',
                ),
                onChanged: (value) {
                  inputData = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('??????'),
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
