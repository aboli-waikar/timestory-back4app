import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:timestory_back4app/converters/TimeSheetParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/repositories/ProjectRepository.dart';
import 'package:timestory_back4app/repositories/TimeSheetRepository.dart';
import 'package:timestory_back4app/viewModels/DeleteTimeSheetViewModel.dart';
import 'package:timestory_back4app/viewModels/ProjectDataViewModel.dart';
import 'InsertUpdateTimeSheet.dart';
import 'package:timestory_back4app/views/Projects.dart';

class ReadTimeSheet extends StatefulWidget {
  static String routeName = '/ReadTimeSheet';

  const ReadTimeSheet({Key? key}) : super(key: key);

  @override
  _ReadTimeSheetState createState() => _ReadTimeSheetState();
}

class _ReadTimeSheetState extends State<ReadTimeSheet> {
  List<DeleteTimeSheetViewModel> listDelTSViewModel = [];
  List<TimeSheetDataModel> tsModelList = [];
  List<DropdownMenuItem<String>> items = [];
  List<ProjectDataViewModel> pdvmList = [];

  var selectedMonth;
  Object? projectSelected = '';

  var projRepo = ProjectRepository();
  var tsRepo = TimeSheetRepository();
  var tsToPoConv = TimeSheetParseObjectConverter();

  @override
  void initState() {
    super.initState();
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
  }

  @protected
  @mustCallSuper
  void dispose() {
    assert(_debugLifecycleState == _StateLifecycle.ready);
    assert(() {
      _debugLifecycleState = _StateLifecycle.defunct;
      return true;
    }());
  }

  projectDialog() {
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
      listDelTSViewModel.forEach((e) => e.isDelete = true);
      //debugPrint(listDelTSViewModel.join(", "));
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
      //getTSData();
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
    var appBarWithDeleteIcon = AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
      ),
      title: Text("$projectSelected", style: const TextStyle(fontSize: 16.0)),
      actions: [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              listDelTSViewModel.where((element) => element.isDelete == true).map((e) => tsRepo.delete(e.tsModel));
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

    if (listDelTSViewModel.any((element) => element.isDelete == true)) {
      return appBarWithDeleteIcon;
    } else {
      return appBar;
    }
  }

  Future<List<DeleteTimeSheetViewModel>> getTSData() async {
    debugPrint("ReadTimeSheet:getTSData selectedMonth:${selectedMonth.toString()}");
    tsModelList = await tsRepo.getAll();
    List<DeleteTimeSheetViewModel> tempList = [];
    if (selectedMonth == null) {
      for (var t in tsModelList) {
        tempList.add(DeleteTimeSheetViewModel(t, ProjectDataViewModel(await projRepo.getById(t.projectDM.objectId)), false));
      }
    } else {
      var tsmList = tsModelList.where((element) => getMonth(element.selectedDate) == getMonth(selectedMonth)).toList();
      for (var t in tsmList) {
        tempList.add(DeleteTimeSheetViewModel(t, ProjectDataViewModel(await projRepo.getById(t.projectDM.objectId)), false));
      }
    }
    listDelTSViewModel = tempList;
    return listDelTSViewModel;
  }

  void copyData(List<DeleteTimeSheetViewModel> initialData) {
    listDelTSViewModel = initialData;
    debugPrint('Initial Data: ${initialData.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("TimeSheet"),),
      appBar: getAppBar(),
      body: FutureBuilder<List<DeleteTimeSheetViewModel>>(
        future: getTSData(),
        builder: (context, AsyncSnapshot snapshot) {

          if (snapshot.data == null) {
            return const Center(
              child: Text("Loading"),
            );
          } else {
            //copyData(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (bool? newValue) {
                        setState(() {
                          snapshot.data[index].isDelete = newValue!;
                          debugPrint('current value: ${listDelTSViewModel[index].isDelete}');
                          String id = snapshot.data[index].tsModel.objectId;
                          debugPrint('$id');
                          //copyData(snapshot.data);
                        });
                      },
                    ),
                    title: Column(children: [
                      Row(
                        children: [
                          const Text("Project: ", style: TextStyle(fontSize: 13.0)),
                          Text(snapshot.data[index].pdvModel.projectIdName, style: const TextStyle(fontSize: 15.0)),

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
