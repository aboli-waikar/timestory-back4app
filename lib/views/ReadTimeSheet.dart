import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart' as kIsWeb;
import 'package:universal_html/html.dart' as html; //For Web download
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:timestory_back4app/converters/TimeSheetParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/repositories/ProjectRepository.dart';
import 'package:timestory_back4app/repositories/TimeSheetRepository.dart';
import 'package:timestory_back4app/util/ExportTimeSheet.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'package:timestory_back4app/viewModels/TimeSheetViewModel.dart';
import 'package:timestory_back4app/viewModels/ProjectDataViewModel.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import 'InsertUpdateTimeSheet.dart';

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
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    debugPrint("***ReadTimeSheet: InitState");
    super.initState();
    getTimeSheetFromDB();
  }

  projectDialog() async {
    debugPrint("***ReadTimeSheet: projectDialog");
    var pdmList = await getProjectList();
    pdvmList = pdmList.map((pdm) => ProjectDataViewModel(pdm)).toList();
    projectSelected = pdvmList[0].projectIdName!;
    items = pdvmList.map((pdvm) {
      return DropdownMenuItem(value: pdvm.projectIdName, child: Text(pdvm.projectIdName!));
    }).toList();

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
          actions: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))],
        );
      },
    );
  }

  selectAll() {
    setState(() {
      tsvmList.forEach((e) => e.isDelete = true);
    });
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? d = await showMonthPicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
    setState(() {
      selectedMonth = d;
    });
  }

  deleteTS() async {
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
              Container(margin: const EdgeInsets.only(left: 10), child: Text("Delete in progress...")),
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigateMenuTopBar(index: 1)), (route) => false);
  }

  exportTS() async {
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
              Container(margin: const EdgeInsets.only(left: 10), child: Text("Export in progress...")),
            ],
          ),
        );
      },
    );

    var tsModelList = tsvmList.where((element) => element.isDelete == true).toList().map((e) => e.tsModel).toList();

    var bytes = await exportToPDF(tsModelList, selectedMonth != null ? getMonth(selectedMonth) : ""); //Send Project name here
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NavigateMenuTopBar(index: 1)), (route) => false);
  }

  PreferredSize getAppBar() {
    debugPrint("***ReadTimeSheet:getAppBar");
    PreferredSize appBarWithDeleteIcon = PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("$projectSelected", style: const TextStyle(fontSize: 16.0)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteTS(),
            tooltip: "DELETE",
          ),
          IconButton(
            icon: const Icon(Icons.select_all_rounded),
            onPressed: () => selectAll(),
            tooltip: "SELECT ALL",
          ),
        ],
      ),
    );

    PreferredSize appBar = PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 70),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("PROJECT SELECTED: $projectSelected  ", style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ),
          ]),
          Column(
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.work_outline, color: Colors.black), onPressed: () => projectDialog(), tooltip: "SELECT PROJECT"),
                  IconButton(
                      icon: const Icon(Icons.calendar_today, color: Colors.black), onPressed: () => selectMonth(context), tooltip: "SELECT MONTH"),
                  IconButton(icon: const Icon(Icons.import_export_sharp, color: Colors.black), onPressed: () => exportTS(), tooltip: "EXPORT"),
                ],
              ),
            ],
          ),
        ]));

    if (tsvmList.any((element) => element.isDelete == true)) {
      return appBarWithDeleteIcon;
    } else {
      return appBar;
    }
  }

  Future<List<TimeSheetViewModel>> getTSData() async {
    debugPrint("***ReadTimeSheet: getTSData");
    if (selectedMonth == null) {
      return tsvmList;
    } else {
      return tsvmList.where((element) => getMonth(element.tsModel.selectedDate) == getMonth(selectedMonth)).toList();
    }
  }

  getTimeSheetFromDB() async {
    debugPrint("***ReadTimeSheet: getTimeSheetList");
    tsModelList = await getTimeSheetList();
    if (mounted) {
      setState(() {
        tsvmList = tsModelList.map((tsModel) => TimeSheetViewModel(tsModel, false)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("***ReadTimeSheet:Build");
    return Scaffold(
        appBar: getAppBar(),
        body: FutureBuilder<List<TimeSheetViewModel>>(
          future: getTSData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("Loading"),
              );
            } else if (snapshot.hasData && snapshot.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 100, height: 100, child: Image(image: AssetImage("images/CreateTimeSheet.png"))),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("No data to display"),
                    ),
                  ],
                ),
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
                            Text("${snapshot.data[index].tsModel.projectDM.projectId} - ${snapshot.data[index].tsModel.projectDM.name}",
                                style: const TextStyle(fontSize: 15.0)),
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
                            Text(getHrsMin(getMins(snapshot.data[index].tsModel.numberOfHrs)),
                                style: const TextStyle(fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.bold))
                          ],
                        )
                      ]),
                      subtitle: Text(snapshot.data[index].tsModel.workDescription, style: const TextStyle(fontSize: 14.0, color: Colors.green)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet(snapshot.data[index].tsModel)));
                        //Navigator.pushReplacementNamed(context, '/');
                      });
                },
              );
            }
          },
        ));
  }
}
