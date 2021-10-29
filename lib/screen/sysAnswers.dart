import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:ysi/models/project.dart';
import 'package:ysi/widgets/styles.dart';

class SysAnswers extends StatefulWidget {
  final Project? project;
  const SysAnswers({Key? key, this.project}) : super(key: key);

  @override
  _SysAnswersState createState() => _SysAnswersState();
}

class _SysAnswersState extends State<SysAnswers> {
  late Project project;
  List<LinkcodeData> linkCodeDataList = [];

  void initState() {
    iniProject();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1024),
          child: ListView(
            children: [
              SizedBox(
                height: 32,
              ),
              Center(
                child: Text(
                  project.qa!.name!,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...project.qa!.questions!
                        .asMap()
                        .map((i, element) => MapEntry(
                              i,
                              questionsContainer(i),
                            ))
                        .values
                        .toList(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void iniProject() {
    if (this.mounted) {
      setState(() {
        project = widget.project!;
        project.linkcodes!.asMap().forEach((index, element) {
          linkCodeDataList.add(LinkcodeData(
            name: element.name!,
            questionDataList: [],
          ));
          project.qa?.questions?.asMap().forEach((qkey, qvalue) {
            linkCodeDataList[index].questionDataList?.add(QuestionData(
                no: qvalue.no!, title: qvalue.title!, optionsDataList: []));
            qvalue.aoptions?.asMap().forEach((okey, ovalue) {
              var count = project.answers!
                  .where((answer) =>
                      answer.qnumber == qvalue.no &&
                      answer.score == ovalue.no &&
                      answer.linkcodeid == element.id)
                  .toList()
                  .length;
              linkCodeDataList[index]
                  .questionDataList?[qkey]
                  .optionsDataList
                  ?.add(OptionData(
                    no: ovalue.no!,
                    title: ovalue.no.toString() + '.' + ovalue.title!,
                    count: count,
                  ));
            });
          });
        });
      });
    }
    inspect(linkCodeDataList);
  }

  Widget questionsContainer(int questionIndex) {
    return Card(
      color: blueGrey.withOpacity(.2),
      elevation: 8,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      margin: EdgeInsets.fromLTRB(6, 8, 6, 16),
      child: Padding(
        padding: const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ListTile(
                leading: CircleAvatar(
                  child: Center(
                    child: Text(
                      project.qa!.questions![questionIndex].no.toString(),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  backgroundColor: whiteSmoke,
                  foregroundColor: darkBlueGrey3,
                ),
                title: Text(
                  project.qa!.questions![questionIndex].title!,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelIntersectAction: AxisLabelIntersectAction.rotate45,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: whiteSmoke,
                  fontFamily: 'googlesan',
                ),
                tickPosition: TickPosition.inside,
                // plotOffset: 1,
                majorGridLines: MajorGridLines(width: 0),
                minorGridLines: MinorGridLines(
                  width: 0,
                ),
                minorTicksPerInterval: 0,
                majorTickLines: MajorTickLines(size: 4),
                isVisible: true,
                // maximumLabelWidth: 32,
              ),
              primaryYAxis: NumericAxis(
                interval: 1,
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'googlesan',
                ),
              ),
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  textStyle: TextStyle(
                      fontFamily: 'googlesean',
                      textBaseline: TextBaseline.alphabetic),
                  format: 'series.name:  point.y',
                ),
              ),
              legend: Legend(
                isVisible: true,
                toggleSeriesVisibility: true,
                isResponsive: true,
                overflowMode: LegendItemOverflowMode.wrap,
                position: LegendPosition.bottom,
                textStyle: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'googlesan',
                ),
              ),
              series: <ChartSeries<OptionData, String>>[
                ...linkCodeDataList.map(
                  (e) => ColumnSeries<OptionData, String>(
                      dataSource:
                          e.questionDataList![questionIndex].optionsDataList!,
                      xValueMapper: (OptionData data, _) => data.title,
                      yValueMapper: (OptionData data, _) => data.count,
                      dataLabelMapper: (OptionData data, _) => data.title,
                      name: e.name,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: false,
                        showZeroValue: true,
                        textStyle: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'googlesan',
                        ),
                      ),
                      animationDuration: 2000,
                      width: 0.6, // Width of the bars
                      spacing: 0.3 // Spacing between the bars

                      // sortFieldValueMapper: (PlaceData data, _) => data.value,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OptionData {
  OptionData({this.title = '', this.no = 0, this.count = 0});

  String title;
  int no;

  int count;
}

class QuestionData {
  String title;
  int no;

  List<OptionData>? optionsDataList;
  QuestionData({
    this.title = '',
    this.no = 0,
    this.optionsDataList,
  });
}

class LinkcodeData {
  String name;
  List<QuestionData>? questionDataList;
  LinkcodeData({
    this.name = '',
    this.questionDataList,
  });
}
