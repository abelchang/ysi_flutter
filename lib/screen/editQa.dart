import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:ysi/models/aoption.dart';

import 'package:ysi/models/project.dart';
import 'package:ysi/models/qa.dart';
import 'package:ysi/models/question.dart';
import 'package:ysi/services/projectSerivce.dart';

import 'package:ysi/widgets/styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class EditQA extends StatefulWidget {
  final Project project;
  const EditQA({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  _EditQAState createState() => _EditQAState();
}

class _EditQAState extends State<EditQA> {
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  Qa qa = Qa(questions: []);
  bool isLoading = false;
  bool getSample = false;
  Project project = Project(name: '', qa: Qa(questions: []));
  List<TextEditingController> questionControllers = [];
  List<List<TextEditingController>> optionControllers = [];
  List<Qa?> samples = [];
  bool checkSample = false;

  double _horizontalOffset = 0.4;
  double _verticalOffset = 0;
  bool _topBottom = false;
  double _scale = 0.8;
  double _borderRadius = 0;

  void initState() {
    initQa();
    // _getwidthContainer();
    super.initState();
  }

  initQa() async {
    project = widget.project;
    if (widget.project.qa != null) {
      modifyQa(widget.project.qa!);
    } else {
      addQuestion();
    }
    if (this.mounted) {
      setState(() {
        getSample = true;
      });
    }
    var res = await ProjectService().getAllSamples();
    if (res['success']) {
      samples = res['samples'];
    }
    if (this.mounted) {
      setState(() {
        getSample = false;
      });
    }
  }

  void dispose() {
    super.dispose();
    _scrollController.dispose();
    for (var i = 0; i < qa.questions!.length; i++) {
      questionControllers[i].dispose();
      for (var o = 0; o < qa.questions![i].aoptions!.length; o++) {
        optionControllers[i][o].dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      offset: IDOffset.only(
          top: _topBottom ? _verticalOffset : 0.0,
          bottom: !_topBottom ? _verticalOffset : 0.0,
          right: (MediaQuery.of(context).size.width > 1024)
              ? 0
              : _horizontalOffset,
          left: (MediaQuery.of(context).size.width > 1024)
              ? 0
              : _horizontalOffset),
      scale: IDOffset.horizontal(
          (MediaQuery.of(context).size.width > 1024) ? 0.9 : _scale),
      borderRadius: _borderRadius,
      // duration: Duration(milliseconds: 11200),
      // swipe: _swipe,
      // proportionalChildArea: _proportionalChildArea,
      // backgroundColor: Colors.red,

      // colorTransitionScaffold: Colors.white.withOpacity(.3),
      // rightAnimationType: _animationType,

      rightChild: Material(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 64,
                  // ),
                  // Align(
                  //   alignment: Alignment.bottomLeft,
                  //   child: Text(
                  //     '匯入問卷範本',
                  //     // style: TextStyle(fontSize: 24),
                  //   ),
                  // ),
                  // Divider(
                  //   color: lightBrown,
                  // ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      ...samples.map(
                        (e) => Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  e!.name!,
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(
                                    Icons.system_update_alt,
                                    color: whiteSmoke,
                                    size: 14,
                                  ),
                                  onPressed: () {
                                    e.id = qa.id;
                                    if (this.mounted) {
                                      setState(() {
                                        modifyQa(e);
                                      });
                                    }
                                    _innerDrawerKey.currentState!.toggle();
                                  },
                                ),
                                SizedBox(
                                  height: 48,
                                ),
                                // ListTile(
                                //   dense: true,
                                //   title: Text(
                                //     e!.name!,
                                //     style: TextStyle(color: whiteSmoke),
                                //   ),
                                //   trailing: IconButton(
                                //     icon: Icon(
                                //       Icons.system_update_alt,
                                //       color: whiteSmoke,
                                //     ),
                                //     onPressed: () {
                                //       e.id = qa.id;
                                //       if (this.mounted) {
                                //         setState(() {
                                //           modifyQa(e);
                                //         });
                                //       }
                                //       _innerDrawerKey.currentState!.toggle();
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
      scaffold: Scaffold(
        appBar: AppBar(
          title: Text('專案問卷'),
          iconTheme: IconThemeData(
            color: whiteSmoke, //change your color here
          ),
          leading: BackButton(),
          actions: [
            (getSample || samples.isEmpty)
                ? SizedBox.shrink()
                : Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.system_update_alt),
                      onPressed: () => _innerDrawerKey.currentState!.toggle(),
                    ),
                  ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: isLoading
            ? CircularProgressIndicator(
                color: whiteSmoke,
              )
            : editButton(),
        body: GestureDetector(
          onTap: unfocus,
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
              unselectedWidgetColor: whiteSmoke,
            ),
            child: ListView(
              controller: _scrollController,
              children: [
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 1024),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 16,
                      ),
                      child: createQa(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void modifyQa(Qa qaData) {
    qa = qaData;
    questionControllers.clear();
    optionControllers.clear();
    for (var i = 0; i < qa.questions!.length; i++) {
      questionControllers.add(TextEditingController());
      optionControllers.add([]);
      questionControllers[i].text = qa.questions![i].title ?? '';
      for (var o = 0; o < qa.questions![i].aoptions!.length; o++) {
        optionControllers[i].add(TextEditingController());
        optionControllers[i][o].text =
            qa.questions![i].aoptions![o].title ?? '';
      }
    }
  }

  List<Widget> _getQuestions() {
    List<Widget> questionsTextFields = [];
    for (int i = 0; i < qa.questions!.length; i++) {
      questionsTextFields.add(_title(i));
    }
    return questionsTextFields;
  }

  unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  addQuestion() {
    questionControllers.add(TextEditingController());
    optionControllers.add([]);
    optionControllers[qa.questions!.length].add(TextEditingController());
    if (this.mounted) {
      setState(() {
        Question qJson =
            Question(no: qa.questions!.length + 1, aoptions: [Aoption(no: 1)]);
        qa.questions!.add(qJson);
        qa.questions?.sort((a, b) => a.no!.compareTo(b.no!));
      });
    }
    // debugPrint('add a question');
    // inspect(qa.questions);
  }

  removeQuestion(int index) {
    setState(() {
      qa.questions!.removeAt(index);
      questionControllers.removeAt(index);
      optionControllers.removeAt(index);
      qa.questions!.map((e) {
        var i = qa.questions!.indexOf(e);
        e.no = i + 1;
      }).toList();
    });

    // debugPrint('remove a $index question');
    // inspect(qa.questions);
  }

  addOption(int qIndex, int oIndex) {
    optionControllers[qIndex].add(TextEditingController());
    setState(() {
      Aoption qJson = Aoption(no: oIndex);
      qa.questions![qIndex].aoptions!.add(qJson);
      qa.questions![qIndex].aoptions?.sort((a, b) => a.no!.compareTo(b.no!));
    });
    // debugPrint('add a option');
    // inspect(qa.questions![qIndex]);
  }

  removeOption(int qIndex, int oIndex) {
    setState(() {
      qa.questions![qIndex].aoptions!.removeAt(oIndex);
      optionControllers[qIndex].removeAt(oIndex);
      qa.questions![qIndex].aoptions!.map((e) {
        var i = qa.questions![qIndex].aoptions!.indexOf(e);
        e.no = i + 1;
      }).toList();
    });
    // debugPrint('remove a option');
    // inspect(qa.questions![qIndex]);
  }

  Widget createQa() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          projectInfo(),
          Text(
            '問卷',
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(
            height: 8,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                qaName(),
                SizedBox(
                  height: 16,
                ),
                ..._getQuestions(),
              ],
            ),
          ),
          Container(
            child: CheckboxListTile(
              activeColor: lightBrown,
              checkColor: whiteSmoke,
              controlAffinity: ListTileControlAffinity.platform,
              value: checkSample,
              title: Text(
                "是否要同時儲存為範本呢？",
                style: TextStyle(color: whiteSmoke),
              ),
              onChanged: (value) {
                if (this.mounted) {
                  setState(() {
                    checkSample = value!;
                  });
                }
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    addQuestion();
                    if (_scrollController.position.minScrollExtent !=
                        _scrollController.position.maxScrollExtent) {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 257,
                          duration: Duration(milliseconds: 800),
                          curve: Curves.ease);
                    }
                  });
                },
                child: Text('新增題目'),
              ),
            ],
          ),
          SizedBox(
            height: 32,
          )
        ],
      ),
    );
  }

  Widget qaName() {
    return Card(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   bottomLeft: Radius.circular(20),
      //   bottomRight: Radius.circular(20),
      // )),
      color: whiteSmoke,
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          border:
              Border(top: BorderSide(color: Colors.redAccent[100]!, width: 8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "問卷名稱",
              labelStyle: TextStyle(),
            ),
            initialValue: qa.name,
            // cursorColor: whiteSmoke,
            scrollPadding: EdgeInsets.all(90),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return '此欄位不能留空';
              } else {
                qa.name = value;
                return null;
              }
            },
          ),
        ),
      ),
    );
  }

  projectInfo() {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Card(
          color: blueGrey.withOpacity(.2),
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          margin: EdgeInsets.only(bottom: 16, top: 8, left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                widget.project.name,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '輔導公司：' + widget.project.company!.name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '專案期間: ' +
                        DateFormat('yyyy/MM/dd').format(widget.project.start!) +
                        ' - ' +
                        DateFormat("MM/dd").format(widget.project.end!),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              leading: Icon(
                Icons.receipt_long,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _title(int index) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              // topRight: Radius.circular(20),
              bottomRight: Radius.circular(35))),
      color: whiteSmoke,
      margin: EdgeInsets.only(bottom: 16, top: 8, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: lightBrown, width: 8)),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                // leading: Text('題號.${index + 1}'),
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),

                subtitle: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: questionControllers[index],
                  // initialValue: qa.questions![index].title,
                  // cursorColor: whiteSmoke,
                  scrollPadding: EdgeInsets.all(90),

                  decoration: InputDecoration(
                    hintText: "題目描述",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '此欄位不能留空';
                    } else {
                      qa.questions![index].title = value;
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: index >= 0
                    ? qa.questions![index].aoptions!.map((item) {
                        var i = qa.questions![index].aoptions!.indexOf(item);
                        return _option(i, index);
                      }).toList()
                    : [],
              ),
              Divider(),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () async {
                      addOption(
                          index, qa.questions![index].aoptions!.length + 1);
                      if (_scrollController.position.minScrollExtent !=
                          _scrollController.position.maxScrollExtent) {
                        _scrollController.animateTo(
                            _scrollController.offset + 56,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease);
                      }
                      // print('_scrollController.offset:' +
                      //     _scrollController.offset.toString());
                    },
                    child: Text('增加選項'),
                  ),
                  TextButton(
                    onPressed: () async {
                      removeQuestion(index);
                    },
                    child: Text('移除此題'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(int oIndex, int qIndex) => Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            Row(
              children: [
                Text('選項${oIndex + 1}:'),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: optionControllers[qIndex][oIndex],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "選項描述",
                      hintStyle: TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.only(
                          left: 15, top: 8, right: 15, bottom: 0),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    scrollPadding: EdgeInsets.all(90),
                    // cursorColor: whiteSmoke,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '此欄位不能留空';
                      } else {
                        qa.questions![qIndex].aoptions![oIndex].title = value;
                        qa.questions![qIndex].aoptions![oIndex].score =
                            qa.questions![qIndex].aoptions![oIndex].no;
                        return null;
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: darkBlueGrey,
                  ),
                  onPressed: () async {
                    removeOption(qIndex, oIndex);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      );

  editButton() {
    return FloatingActionButton(
      backgroundColor: lightBrown,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          project.qa = qa;
          var result = await ProjectService()
              .createProject(project, checkSample: checkSample);
          setState(() {
            if (result['success']) {
              project = result['project'];
              debugPrint('res project success:' + jsonEncode(project));
            }
            isLoading = false;
          });
          Navigator.of(context).pop(project);
        } else {
          return;
        }
      },
      child: Text('儲存'),
      // style: ElevatedButton.styleFrom(
      //   shape: CircleBorder(),
      //   padding: EdgeInsets.all(8),
      // ),
    );
  }
}
