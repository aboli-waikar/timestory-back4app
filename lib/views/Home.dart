import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/util/Utilities.dart';

import '../model/ChartViewModel.dart';
import '../model/TimeSheetDataModel.dart';

class Home extends StatefulWidget {
  static String routeName = '/Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var chModel = ChartViewModel(DateTime.now(), 0, "");
  List<ChartViewModel> _myData = [ChartViewModel(DateTime.now(), 0, "")];
  DateTime selectedMonth = DateTime.now();

  List<ProjectDataModel> projectList = [];
  List<TimeSheetDataModel> tsModelList = [];

  @override
  void initState() {
    super.initState();
    getProjectData();
    getTSData();
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? d = await showMonthPicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    setState(() {
      selectedMonth = d!;
      getTSData();
    });
  }

  getProjectData() async {
    var x = await getProjectList();
      setState(() {
        projectList = x;
      });

  }

  getTSData() async {
    debugPrint("Home:getTSData()");

    tsModelList = await getTimeSheetList();

    setState(() {
      _myData = tsModelList
          .where((tsModel) => getMonth(tsModel.selectedDate) == getMonth(selectedMonth))
          .toList()
          .map((tsModel) => ChartViewModel(tsModel.selectedDate, tsModel.numberOfHrs, "${tsModel.projectDM.projectId} - ${tsModel.projectDM.name}"))
          .toList();
    });
    debugPrint('MyData: ${_myData.join(", ").toString()}');
  }

  Widget getTSChart(String projectName) {
    debugPrint("Home:getTSChart ProjectName: $projectName");

    final List<Charts.Series<ChartViewModel, DateTime>> seriesList = [
      Charts.Series<ChartViewModel, DateTime>(
        id: 'chart000',
        domainFn: (ChartViewModel chViewModel, _) => (chViewModel.projectIdName == projectName) ? chViewModel.Date : DateTime.now(),
        measureFn: (ChartViewModel chViewModel, _) => (chViewModel.projectIdName == projectName) ? chViewModel.numberOfHrs : 0,
        colorFn: (ChartViewModel chViewModel, _) => Charts.MaterialPalette.green.shadeDefault,
        data: _myData,
      ),
    ];

    var currentMonth = getMonthStr(selectedMonth);
    // var tMin = _myData.fold(0, (num prev, ChartViewModel chViewModel) => prev + chViewModel.getMins());
    // String totalHrs = getHrsMin(tMin);

    var totalHrs = getHrsMin(_myData.fold(0, (num prev, ChartViewModel chViewModel) => prev + getMins(chViewModel.numberOfHrs)));

    return ListView(
      children: [
        Container(
          height: 150,
          child: Charts.TimeSeriesChart(
            seriesList,
            animate: true,
            defaultRenderer:
                Charts.BarRendererConfig<DateTime>(groupingType: Charts.BarGroupingType.stacked, cornerStrategy: Charts.ConstCornerStrategy(2)),
            domainAxis: Charts.DateTimeAxisSpec(tickProviderSpec: Charts.DayTickProviderSpec(increments: [2])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text("$currentMonth : $totalHrs", style: const TextStyle(fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getProjectList();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "SELECT MONTH: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                    semanticLabel: "Select Month",
                  ),
                  onPressed: () => selectMonth(context)),
            ],
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 222,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: projectList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text('${projectList[index].projectId} - ${projectList[index].name}'),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                              //color: Theme.of(context).colorScheme.background,
                              padding: MediaQuery.of(context).padding,
                              child: getTSChart('${projectList[index].projectId} - ${projectList[index].name}'),
                              //child: getTSChart(),
                              height: 185,
                              width: 200))
                    ]),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
