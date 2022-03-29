import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:intl/intl.dart';

// import 'package:timesheet/daos/ProjectDAO.dart';
// import 'package:timesheet/models/Project.dart';
// import 'package:timesheet/models/TimesheetUser.dart';
// import 'package:timesheet/daos/TimesheetTable.dart';
// import 'package:timesheet/views/ToDo.dart';
// import '../models/ChartViewModel.dart';
// import '../daos/TimesheetDAO.dart';
// import '../models/Timesheet.dart';


class Home extends StatefulWidget {
  static String routeName = '/Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //var chModel = ChartViewModel(DateTime.now(), 0, 'Default');
  //List<ChartViewModel> _myData = [ChartViewModel(DateTime.now(), 0, 'Default')];
  DateTime selectedMonth = DateTime.now();
  //final prDAO = ProjectDAO();
  //final tsDAO = TimesheetDAO();
  List<String> projectList = [''];
  //var projectName = 'Default';

  @override
  void initState() {
    super.initState();
    getTSData();
    getProjectList();
  }

  getMonth(DateTime dT) {
    final DateFormat formatter = DateFormat('yyyy-MM');
    var yearMonth = formatter.format(dT);
    return yearMonth;
  }

  getMonthStr(DateTime dT) {
    final DateFormat formatter = DateFormat('MMM-yyyy');
    var yearMonth = formatter.format(dT);
    return yearMonth;
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? d = await showMonthPicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    setState(() {
      selectedMonth = d!;
      getTSData();
    });
  }

  Future getProjectList() async {
    debugPrint("Home - In getProjectList");
    // List prMapList = await prDAO.getAll(prDAO.pkColumn);
    // List<Project> prModels = prMapList.map((e) => Project.convertToProject(e)).toList();
    // projectList = prModels.map((e) => e.name).toList();
    // debugPrint(projectList.toString());
    return projectList;
  }

  Future getTSData() async {
    debugPrint("In getTSData()");
    // var tsPrDBRows = await tsDAO.getTimeSheetAndProjectName();
    // var tsPrModels = tsPrDBRows.map((e) => TimeSheet.convertToProjectTimeSheet(e)).toList();
    // debugPrint('From Database: ${tsPrDBRows.toString()}');
    // debugPrint('From Map: ${tsPrModels.toString()}');
    //
    // //debugPrint(tsModels.join(", ").toString());
    // //Need a joint query here as get Project is not working.
    // setState(() {
    //   //debugPrint(selectedMonth.toString());
    //   _myData = tsPrModels.where((tsModel) => getMonth(tsModel.selectedDate) == getMonth(selectedMonth)).map((tsModel) {
    //     return ChartViewModel(tsModel.selectedDate, tsModel.hrs, tsModel.project.name);
    //   }).toList();
    // });
    // debugPrint('MyData: ${_myData.join(", ").toString()}');
  }

  Widget getTSChart(String projectName) {
    debugPrint("ProjectName: $projectName");
    // //var currentChVM = _myData.where((element) => element.projectName == projectName).first;
    // final List<Charts.Series<ChartViewModel, DateTime>> seriesList = [
    //   Charts.Series<ChartViewModel, DateTime>(
    //     id: 'chart000',
    //     domainFn: (ChartViewModel chViewModel, _) => (chViewModel.projectName == projectName)? chViewModel.date : DateTime.now(),
    //     // domainFn: (ChartViewModel chViewModel, _) => currentChVM.date,
    //     measureFn: (ChartViewModel chViewModel, _) => (chViewModel.projectName == projectName)? chViewModel.hrs : 0,
    //     // measureFn: (ChartViewModel chViewModel, _) => currentChVM.hrs,
    //     colorFn: (ChartViewModel chViewModel, _) => Charts.MaterialPalette.green.shadeDefault,
    //     data: _myData,
    //   ),
    // ];
    //
    var currentMonth = getMonthStr(selectedMonth);
    // var tMin = _myData.fold(0, (prev, ChartViewModel element) => prev + element.getMins());
    var totalHrs = 10;//chModel.getHrsMin(tMin);

    return ListView(
      children: [
        Container(
          height: 150,
          // child: Charts.TimeSeriesChart(
          //   seriesList,
          //   animate: true,
          //   defaultRenderer:
          //   Charts.BarRendererConfig<DateTime>(groupingType: Charts.BarGroupingType.stacked, cornerStrategy: Charts.ConstCornerStrategy(2)),
          //   domainAxis: Charts.DateTimeAxisSpec(tickProviderSpec: Charts.DayTickProviderSpec(increments: [2])),
          // ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
                "$currentMonth: $totalHrs hours",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getProjectList();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,70),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("SELECT MONTH: ", style: TextStyle(fontWeight: FontWeight.bold),),
                IconButton(icon: const Icon(Icons.calendar_today, color: Colors.black, semanticLabel: "Select Month",), onPressed: () => selectMonth
                  (context)),
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
                      Text('${projectList[index]}'),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            //color: Theme.of(context).colorScheme.background,
                              padding: MediaQuery.of(context).padding,
                              child: getTSChart('${projectList[index]}'),
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
