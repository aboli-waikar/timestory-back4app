import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' as kIsWeb;
import 'package:open_file/open_file.dart';
import 'package:timestory_back4app/main.dart';
import 'package:timestory_back4app/repositories/TimeSheetRepository.dart';
import 'package:universal_html/html.dart' as html; //For Web download
import 'package:charts_flutter/flutter.dart' as Charts;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/util/ExportTimeSheet.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'package:timestory_back4app/viewModels/ProjectDataViewModel.dart';
import 'package:timestory_back4app/viewModels/TimeSheetViewModel.dart';
import 'package:timestory_back4app/views/InsertUpdateTimeSheet.dart';

import '../model/ChartViewModel.dart';
import '../model/TimeSheetDataModel.dart';

class TimeSheet extends StatefulWidget {
  static String routeName = '/TimeSheet';

  const TimeSheet({kIsWeb.Key? key}) : super(key: key);

  @override
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {
  var chModel = ChartViewModel(DateTime.now(), 0, "");
  List<ChartViewModel> _myData = [ChartViewModel(DateTime.now(), 0, "")];
  DateTime selectedMonth = DateTime.now();

  List<ProjectDataModel> initialProjectList = [];
  List<TimeSheetDataModel> tsModelList = [];

  List<TimeSheetViewModel> tsvmList = [];
  List<ProjectDataViewModel> pdvmList = [];
  Object? selectedProject = '';
  late final String? initialSelectedProject;
  List<DropdownMenuItem<String>> items = [];
  var tsRepo = TimeSheetRepository();

  @override
  void initState() {
    super.initState();
    debugPrint("Home: initState()");
    getProjectData();
    getTimeSheetFromDB();
    getTSData();
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? d = await showMonthPicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    if (mounted) {
      setState(() {
        if (d != null) selectedMonth = d;
        getTSData();
      });
    }
  }

  getProjectData() async {
    debugPrint("Home: getProjectData()");
    var x = await getProjectList();
    setState(() {
      initialProjectList = x;
      pdvmList = initialProjectList.map((pdm) => ProjectDataViewModel(pdm)).toList();
      initialSelectedProject = pdvmList[0].projectIdName;
      items = pdvmList.map((pdvm) {
        return DropdownMenuItem(value: pdvm.projectIdName, child: Text(pdvm.projectIdName!));
      }).toList();
    });
  }

  selectProject() {
    debugPrint("Home: selectProject()");
    selectedProject = (selectedProject == '') ? initialSelectedProject : selectedProject;
    debugPrint(selectedProject.toString());
    showDialog(
      context: context,
      builder: (context) {
        Object? tempSelectedProject = selectedProject;
        return AlertDialog(
          title: const Text("Change Project"),
          content: DropdownButton(
            value: selectedProject,
            isDense: true,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            items: items,
            onChanged: (selectedItem) => tempSelectedProject = selectedItem,
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((item) {
                return DropdownMenuItem(value: item, child: Text(tempSelectedProject.toString()));
              }).toList();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedProject = tempSelectedProject;
                        pdvmList = initialProjectList
                            .map((pdm) => ProjectDataViewModel(pdm))
                            .toList()
                            .where((element) => element.projectIdName == selectedProject)
                            .toList();
                      });

                      Navigator.of(context).pop();
                    },
                    child: const Text("OK")),
                ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("CANCEL")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedProject = "";
                        pdvmList = initialProjectList.map((pdm) => ProjectDataViewModel(pdm)).toList();
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text("RESET"))
              ]),
            )
          ],
        );
      },
    );
  }

  getTimeSheetFromDB() async {
    debugPrint("Home: getTimeSheetList()");
    tsModelList = await getTimeSheetList();
    if (mounted) {
      setState(() {
        tsvmList = tsModelList.map((tsModel) => TimeSheetViewModel(tsModel, false)).toList();
      });
    }
  }

  Future<List<TimeSheetViewModel>> getTSData() async {
    debugPrint("Home:getTSData()");

    setState(() {
      _myData = tsModelList
          .where((tsModel) => getMonth(tsModel.selectedDate) == getMonth(selectedMonth))
          .toList()
          //.where((tsModel) => ProjectDataViewModel(tsModel.projectDM).projectIdName == selectedProject)
          .map((tsModel) => ChartViewModel(tsModel.selectedDate, tsModel.numberOfHrs, "${tsModel.projectDM.projectId} - ${tsModel.projectDM.name}"))
          .toList();
    });
    //debugPrint('MyData: ${_myData.join(", ").toString()}');

    if (selectedProject == '') {
      return tsvmList.where((element) => getMonth(element.tsModel.selectedDate) == getMonth(selectedMonth)).toList();
    } else {
      return tsvmList
          .where((element) => getMonth(element.tsModel.selectedDate) == getMonth(selectedMonth))
          .toList()
          .where((element) => ProjectDataViewModel(element.tsModel.projectDM).projectIdName == selectedProject)
          .toList();
    }
  }

  Widget getTSChart(String projectName) {
    debugPrint("Home:getTSChart()");
    final List<Charts.Series<ChartViewModel, DateTime>> seriesList = [
      Charts.Series<ChartViewModel, DateTime>(
        id: 'chart000',
        domainFn: (ChartViewModel chViewModel, _) => (chViewModel.projectIdName == projectName) ? chViewModel.Date : DateTime.now(),
        measureFn: (ChartViewModel chViewModel, _) => (chViewModel.projectIdName == projectName) ? chViewModel.numberOfHrs : 0,
        //colorFn: (ChartViewModel chViewModel, _) => Charts.MaterialPalette.green.shadeDefault,
        data: _myData,
      ),
    ];

    var currentMonth = getMonthStr(selectedMonth);
    // var tMin = _myData.fold(0, (num prev, ChartViewModel chViewModel) => prev + chViewModel.getMins());
    // String totalHrs = getHrsMin(tMin);

    var totalHrs = getHrsMin(_myData.fold(
        0, (num prev, ChartViewModel chViewModel) => prev + getMins((chViewModel.projectIdName == projectName) ? chViewModel.numberOfHrs : 0)));

    return ListView(
      children: [
        SizedBox(
          height: 150,
          child: Charts.TimeSeriesChart(
            seriesList,
            animate: true,
            defaultRenderer:
                Charts.BarRendererConfig<DateTime>(groupingType: Charts.BarGroupingType.stacked, cornerStrategy: const Charts.ConstCornerStrategy(2)),
            domainAxis: const Charts.DateTimeAxisSpec(tickProviderSpec: Charts.DayTickProviderSpec(increments: [2])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("$currentMonth : $totalHrs", style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  deleteTS() async {
    debugPrint("Home: deleteTS()");
    dynamic contextToPop;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctxt) {
        contextToPop = ctxt;
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(margin: const EdgeInsets.only(left: 10), child: const Text("Delete in progress...")),
            ],
          ),
        );
      },
    );

    var tsModelList = tsvmList.where((element) => element.isDelete == true).toList().map((e) => e.tsModel).toList();
    for (var tsModel in tsModelList) {
      await tsRepo.delete(tsModel);
    }

    Navigator.of(contextToPop).pop();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TimeStoryApp()), (route) => false);
  }

  exportTS() async {
    debugPrint("Home: exportTS()");
    dynamic contextToPop;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctxt) {
        contextToPop = ctxt;
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(margin: const EdgeInsets.only(left: 10), child: const Text("Export in progress...")),
            ],
          ),
        );
      },
    );

    var tsModelList = tsvmList.where((element) => element.isDelete == true).toList().map((e) => e.tsModel).toList();

    var bytes = await exportToPDF(tsModelList, getMonth(selectedMonth)); //Send Project name here
    if (kIsWeb.kIsWeb) {
      var base64str = base64Encode(bytes);
      var url = "data:application/octet-stream;base64,$base64str";
      html.AnchorElement anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'timeSheet.pdf';
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = documentDirectory.path;
      File file = File('$path/timesheet.pdf');
      print(file.toString());
      await file.writeAsBytes(bytes);
      OpenFile.open('$path/timesheet.pdf');
      return path;
    }

    Navigator.of(contextToPop).pop();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TimeStoryApp()), (route) => false);
  }

  getAppBar() {
    debugPrint("Home:getAppBar()");
    AppBar appBarWithDeleteIcon = AppBar(
      backgroundColor: Colors.deepOrange,
      //toolbarHeight: 100,
      title: Text("$selectedProject", style: const TextStyle(fontSize: 16.0)),
      actions: [
        IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteTS(), tooltip: "DELETE"),
        IconButton(
            icon: const Icon(Icons.select_all_rounded),
            onPressed: () {
              setState(() {
                tsvmList.forEach((e) => e.isDelete = true);
              });
            },
            tooltip: "SELECT ALL"),
      ],
    );

    AppBar appBar = AppBar(
      backgroundColor: Colors.deepOrange,
      //toolbarHeight: 100,
      title: Text("$selectedProject", style: const TextStyle(fontSize: 16.0)),
      actions: [
        IconButton(icon: const Icon(Icons.work_outline, color: Colors.black), onPressed: () => selectProject(), tooltip: "SELECT PROJECT"),
        IconButton(icon: const Icon(Icons.calendar_today, color: Colors.black), onPressed: () => selectMonth(context), tooltip: "SELECT MONTH"),
        IconButton(icon: const Icon(Icons.import_export_sharp, color: Colors.black), onPressed: () => exportTS(), tooltip: "EXPORT"),
      ],
    );

    if (tsvmList.any((element) => element.isDelete == true)) {
      return appBarWithDeleteIcon;
    } else {
      return appBar;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("In Build Widget");
    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Number of Records: ${tsvmList.length}", style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                      //Text("Month: ${getMonthStr(selectedMonth)}",style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: pdvmList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Text('${pdvmList[index].projectIdName}'),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                    //color: Theme.of(context).colorScheme.background,
                                    padding: MediaQuery.of(context).padding,
                                    child: getTSChart('${pdvmList[index].projectIdName}'),
                                    //child: getTSChart(),
                                    height: 200,
                                    width: 300))
                          ]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            FutureBuilder<List<TimeSheetViewModel>>(
              future: getTSData(),
              builder: (context, AsyncSnapshot snapshot) {
//                if (!snapshot.hasData) {
                if (tsvmList.isEmpty) {
                  return const SizedBox(
                    height: 500,
                    child: Text("If no data create Timesheet!"),
                  );
                } else {
                  return Card(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        return ListTile(
                            //tileColor: Colors.tealAccent,
                            leading: Checkbox(
                              value: tsvmList[index].isDelete,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  tsvmList[index].isDelete = newValue!;
                                  debugPrint('****TsId selected: ${tsvmList[index].tsModel.objectId}');
                                });
                              },
                            ),
                            title: Column(children: [
                              Row(
                                children: [
                                  const Text("Date: ", style: TextStyle(fontSize: 15.0)),
                                  Expanded(
                                      child: Text(formatDate(snapshot.data[index].tsModel.selectedDate), style: const TextStyle(fontSize: 15.0))),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Project: ", style: TextStyle(fontSize: 15.0)),
                                  Expanded(
                                      child: Text(
                                          "${snapshot.data[index].tsModel.projectDM.projectId} - ${snapshot.data[index].tsModel.projectDM.name}",
                                          style: const TextStyle(fontSize: 15.0))),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Hours Spent: ", style: TextStyle(fontSize: 15.0)),
                                  Expanded(
                                      child: Text(getHrsMin(getMins(snapshot.data[index].tsModel.numberOfHrs)),
                                          style: const TextStyle(fontSize: 14.0, color: Colors.blueAccent, fontWeight: FontWeight.bold)))
                                ],
                              )
                            ]),
                            subtitle:
                                Text(snapshot.data[index].tsModel.workDescription, style: const TextStyle(fontSize: 14.0, color: Colors.blueAccent)),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index].tsModel)));
                              //Navigator.pushReplacementNamed(context, '/');
                            });
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrange),
    );
  }
}
