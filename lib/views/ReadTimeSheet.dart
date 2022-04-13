import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:timestory_back4app/converters/TimeSheetParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/repositories/ProjectRepository.dart';
import 'package:timestory_back4app/repositories/TimeSheetRepository.dart';
import 'package:timestory_back4app/viewModels/TimeSheetViewModel.dart';
import 'package:timestory_back4app/viewModels/ProjectDataViewModel.dart';
import 'InsertUpdateTimeSheet.dart';
import 'package:timestory_back4app/views/Projects.dart';

class ReadTimeSheet extends StatefulWidget {
  static String routeName = '/ReadTimeSheet';

  ReadTimeSheet({Key? key}) : super(key: key);

  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  List<TimeSheetDataModel> tsModelList = [];
  List<TimeSheetViewModel> tsvmList = [];
  List<DropdownMenuItem<String>> items = [];
  List<ProjectDataViewModel> pdvmList = [];

  var selectedMonth;
  Object? projectSelected = '';

  var projRepo = ProjectRepository();
  var tsRepo = TimeSheetRepository();
  var tsToPoConv = TimeSheetParseObjectConverter();

  @override
  void initState() {
    debugPrint("***ReadTimeSheet: InitState");
    super.initState();
    getTimeSheetList().then((value) {
      setState(() {
        tsModelList = value;
        tsvmList = tsModelList.map((tsModel) => TimeSheetViewModel(tsModel, false)).toList();
      });
    });
  }

  projectDialog() {
    debugPrint("***ReadTimeSheet: projectDialog");
    getProjectList().then((value) {
      setState(() {
        List<ProjectDataModel> pdmList = value;
        pdvmList = pdmList.map((pdm) => ProjectDataViewModel(pdm)).toList();
        projectSelected = pdvmList[0].projectIdName!;
        items = pdvmList.map((pdvm) {
          return DropdownMenuItem(value: pdvm.projectIdName, child: Text(pdvm.projectIdName!));
        }).toList();
      });
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Project"),
          content: DropdownButton(
            value: projectSelected,
            isDense: true,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            items: items,
            onChanged: (selectedItem) {
              setState(() {
                projectSelected = selectedItem;
              });
            },
          ),
        );
      },
    );
  }

  selectAll() {
    setState(() {
      tsvmList.forEach((e) => e.isDelete = true);
    });
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
      selectedMonth = d;
    });
  }

  showExportProgressDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(margin: const EdgeInsets.only(left: 10), child: const Text("Exporting to excel..")),
            ],
          ),
        );
      },
    );
  }

  showExportCompleteDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(
                value: 100.0,
              ),
              Container(margin: const EdgeInsets.only(left: 10), child: const Text("Export completed")),
            ],
          ),
        );
      },
    );
  }



  AppBar getAppBar() {
    debugPrint("***ReadTimeSheet:getAppBar");
    var appBarWithDeleteIcon = AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
      ),
      title: Text("$projectSelected", style: const TextStyle(fontSize: 16.0)),
      actions: [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {

               // List<void> tsModelList = tsvmList.where((element) => element.isDelete == true).toList().map((e) => e.tsModel).toList()
               //     .map((e) => tsRepo.delete(e)).toList();

               var tsModelList = tsvmList.where((element) => element.isDelete == true).toList().map((e) => e.tsModel).toList();

               for(var tsModel in tsModelList) {
                 await tsRepo.delete(tsModel);
               }

              Navigator.pushReplacementNamed(context, '/');
            }),
        IconButton(icon: const Icon(Icons.select_all_rounded), onPressed: () => selectAll()),
      ],
    );

    var appBar = AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
      ),
      title: Text("$projectSelected", style: const TextStyle(fontSize: 16.0)),
      actions: [
        IconButton(
          icon: const Icon(Icons.work_outline, color: Colors.white),
          onPressed: () => projectDialog(),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          onPressed: () => selectMonth(context),
        ),
        IconButton(
            icon: const Icon(
              Icons.import_export_sharp,
              color: Colors.white,
            ),
            onPressed: () async {
              //var x = await exportToPDF(timesheetModels, selectedMonth != null ? getMonth(selectedMonth) : null); //Send Project name here
              //debugPrint(x); //get filename here
              //(x != null) ? showExportCompleteDialog() : showExportProgressDialog();
            }),
      ],
    );

    if (tsvmList.any((element) => element.isDelete == true)) {
      return appBarWithDeleteIcon;
    } else {
      return appBar;
    }
  }

  Future<List<TimeSheetViewModel>> getTSData() async {
    List<TimeSheetViewModel> tempList = [];
    // if (selectedMonth == null) {
    //   for (var t in tsModelList) {
    //     tempList.add(TimeSheetViewModel(t, ProjectDataViewModel(await projRepo.getById(t.projectDM.objectId)), false));
    //   }
    // } else {
    //   var tsmList = tsModelList.where((element) => getMonth(element.selectedDate) == getMonth(selectedMonth)).toList();
    //   for (var t in tsmList) {
    //     tempList.add(TimeSheetViewModel(t, ProjectDataViewModel(await projRepo.getById(t.projectDM.objectId)), false));
    //   }
    // }
    //tsvmList = tempList;
    return tsvmList; //= tempList;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("***ReadTimeSheet:Build");
    return Scaffold(
      appBar: getAppBar(),
      body: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return FutureBuilder<List<TimeSheetViewModel>>(
            future: getTSData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: Text("Loading"),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Checkbox(
                          value: snapshot.data[index].isDelete,
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
                              const Text("Project: ", style: TextStyle(fontSize: 13.0)),
                              Text("${snapshot.data[index].tsModel.projectDM.projectId} - ${snapshot.data[index].tsModel.projectDM.name}", style: const
                              TextStyle
                                (fontSize: 15.0)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Date: ", style: TextStyle(fontSize: 15.0)),
                              Text(snapshot.data[index].tsModel.selectedDateStr, style: const TextStyle(fontSize: 15.0)),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Hours Spent: ", style: TextStyle(fontSize: 15.0)),
                              Text(snapshot.data[index].tsModel.numberOfHrs.toString(),
                                  style: const TextStyle(fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ]),
                        subtitle: Text(snapshot.data[index].tsModel.workDescription, style: const TextStyle(fontSize: 14.0, color: Colors.green)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index].tsModel)));
                        });
                  },
                );
              }
            },
          );
        }
      ),
      // floatingActionButton: FloatingActionButton(
      //     tooltip: 'Enter Timesheet',
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
      //     }),
    );
  }
}

Future<List<TimeSheetDataModel>> getTimeSheetList() async {
  var tsRepo = TimeSheetRepository();
  List<TimeSheetDataModel> timeSheetList = await tsRepo.getAllWithProjectModel();
  return timeSheetList;
}
