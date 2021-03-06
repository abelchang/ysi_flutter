import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:ysi/models/answer.dart';
import 'package:ysi/models/linkcode.dart';
import 'package:ysi/models/qa.dart';
import 'package:ysi/services/projectSerivce.dart';
import 'package:ysi/widgets/spinkit.dart';
import 'package:ysi/widgets/styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Qapage extends StatefulWidget {
  final code;
  final bool preview;
  Qapage({
    Key? key,
    this.code,
    this.preview = false,
  }) : super(key: key);

  @override
  _QapageState createState() => _QapageState();
}

class _QapageState extends State<Qapage> {
  late Qa qa;
  late Linkcode linkcode;
  List<Answer> answers = [];
  bool isLoading = true;
  bool sending = false;
  bool isPage = false;
  int totleQuestions = 1;
  int currentAnswer = 0;
  String errormessage = '';
  String pageMessage = '';
  ScrollController _scrollController = ScrollController();
  double titlePosition = 150;
  double bannerPosition = 200;
  bool bannerTitle = true;

  void initState() {
    super.initState();
    initQa();

    _scrollController.addListener(() {
      if (_scrollController.offset >= 10) {
        if (kIsWeb) {
          if (this.mounted) {
            setState(() {
              titlePosition = 0;
              bannerPosition = 56;
              bannerTitle = false;
            });
          }
        } else {
          if (this.mounted) {
            setState(() {
              titlePosition = 26;
              bannerPosition = 72;
              bannerTitle = false;
            });
          }
        }
      } else if (_scrollController.offset == 0) {
        if (this.mounted) {
          setState(() {
            titlePosition = 150;
            bannerPosition = 200;
            bannerTitle = true;
          });
        }
      }
    });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  initQa() async {
    var res = await ProjectService().getQa(widget.code);
    debugPrint('get question');
    inspect(res);
    if (res['success']) {
      qa = res['qa'];
      linkcode = res['linkcode'];
      totleQuestions = qa.questions!.length;
      for (var i = 0; i < qa.questions!.length; i++) {
        answers.add(Answer(
          qnumber: qa.questions![i].no,
          linkcodeid: linkcode.id,
          projectid: linkcode.projectid,
        ));
      }
    } else {
      qa = Qa(name: '');
      linkcode = Linkcode();
      pageMessage = '????????????????????????????????????';
      isPage = true;
    }
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? spinkit
        : Theme(
            data: ThemeData.light().copyWith(
              backgroundColor: whiteSmoke,
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
            child: Scaffold(
              body: isPage ? page(pageMessage) : qaContainer(),
            ),
          );
  }

  Widget qaContainer() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: bannerPosition,
            color: darkBlueGrey3,
            child: Align(
              alignment: Alignment.center,
              child: bannerTitle
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'web/favicon.png',
                          width: 48,
                        ),
                        Text(
                          '????????????????????????',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '',
                    ),
            ),
          ),
          Positioned.fill(
            top: titlePosition,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(maxWidth: 1024),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                      margin:
                          EdgeInsets.only(bottom: 4, top: 8, left: 8, right: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            qa.name ?? '',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text(
                            linkcode.name ?? '',
                            // style: TextStyle(fontSize: 18),
                          ),
                          leading: Icon(
                            Icons.receipt_long,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.zero,
                        child: ListView(
                          shrinkWrap: true,
                          controller: _scrollController,
                          children: [
                            ..._getQaQuestions(),
                            errormessage.isEmpty
                                ? SizedBox(
                                    height: 32,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      errormessage,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.center,
                              child: sending
                                  ? CircularProgressIndicator()
                                  : qaButton(),
                            ),
                            SizedBox(
                              height: 64,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 24.0, left: 12, right: 12),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '$currentAnswer/$totleQuestions',
                                style: TextStyle(color: cardLight2),
                              ),
                            ),
                          ),
                          StepProgressIndicator(
                            totalSteps: totleQuestions,
                            currentStep: currentAnswer,
                            selectedColor: lightBrown,
                            unselectedColor: cardLight2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool positionTitle() {
    if (_scrollController.hasClients) _scrollController.jumpTo(50.0);
    return (_scrollController.position.minScrollExtent !=
        _scrollController.position.maxScrollExtent);
  }

  Widget qaButton() {
    return widget.preview
        ? ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('??????'))
        : ElevatedButton(
            onPressed: () async {
              if (this.mounted) {
                setState(() {
                  sending = true;
                  errormessage = '';
                });
              }

              List<int> errorNo = [];
              for (var i = 0; i < answers.length; i++) {
                if (answers[i].score == null) {
                  errorNo.add(answers[i].qnumber!);
                }
              }
              if (errorNo.isEmpty) {
                var result = await ProjectService().saveAnswers(answers);
                if (result['success']) {
                  print('success');
                  pageMessage = '????????????????????????????????????????????????';
                  isPage = true;
                } else {
                  print('fault');
                }
              } else {
                errorNo.join(" ");
                errormessage = "????????????" + errorNo.join(",") + "????????????????????????";
              }
              if (this.mounted) {
                setState(() {
                  sending = false;
                });
              }
            },
            child: Text('??????'),
          );
  }

  Center page(String message) => Center(
        child: SizedBox(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontFamily: 'googlesan',
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  message,
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
            ),
          ),
        ),
      );

  List<Widget> _getQaQuestions() {
    List<Widget> linkCodeTextFields = [];
    for (int i = 0; i < qa.questions!.length; i++) {
      linkCodeTextFields.add(qaCard(i));
    }
    return linkCodeTextFields;
  }

  Widget qaCard(int i) {
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(bottom: 16, top: 8, left: 8, right: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Column(
          children: [
            ListTile(
              minLeadingWidth: 16,
              title: Text(
                qa.questions![i].title ?? '',
                // style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              leading: Text(
                '${qa.questions![i].no.toString()}.',
                style: TextStyle(fontSize: 22, color: lightBrown),
              ),
            ),
            ..._getQaOptions(i),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getQaOptions(int qIndex) {
    List<Widget> optionsList = [];
    for (int i = 0; i < qa.questions![qIndex].aoptions!.length; i++) {
      optionsList.add(optionTitle(qIndex, i));
    }
    return optionsList;
  }

  Widget optionTitle(int qIndex, int oIndex) {
    return Column(
      children: [
        ListTile(
          dense: true,
          minLeadingWidth: 8,
          horizontalTitleGap: 8,
          contentPadding: EdgeInsets.fromLTRB(40, 0, 8, 0),
          title: Text(
            qa.questions![qIndex].aoptions![oIndex].title!,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          leading: Radio<int>(
            activeColor: lightBrown,
            value: qa.questions![qIndex].aoptions![oIndex].no!,
            groupValue: answers[qIndex].score,
            onChanged: (value) {
              setState(() {
                if (answers[qIndex].score == null) {
                  currentAnswer++;
                }
                answers[qIndex].score = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
