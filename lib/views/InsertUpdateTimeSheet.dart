import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/repositories/TimeSheetRepository.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'package:timestory_back4app/viewModels/ProjectDataViewModel.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import 'package:timestory_back4app/views/QuickAdd.dart';

import '../model/TimeSheetDataModel.dart';

class InsertUpdateTimeSheet extends StatefulWidget {
  final TimeSheetDataModel tsModel;

  InsertUpdateTimeSheet(this.tsModel, {Key? key}) : super(key: key);

  InsertUpdateTimeSheet.defaultModel({Key? key})
      : tsModel = TimeSheetDataModel.nullObjects,
        super(key: key);

  @override
  InsertUpdateTimeSheetState createState() => InsertUpdateTimeSheetState();
}

class InsertUpdateTimeSheetState extends State<InsertUpdateTimeSheet> {
  bool isNewTimeSheet = true;
  var projectSelected;
  late List<ProjectDataViewModel> pdvmList;
  List<DropdownMenuItem<String>> items = [];

  var tsRepo = TimeSheetRepository();

  @override
  void initState() {
    super.initState();
    isNewTimeSheet = (widget.tsModel.objectId == "") ? true : false;
    debugPrint("In Init: isNewTimeSheet: $isNewTimeSheet");
    getProjectList().then(
      (value) {
        setState(() {
          List<ProjectDataModel> pdmList = value;
          pdvmList = pdmList.map((pdm) => ProjectDataViewModel(pdm)).toList();
          projectSelected = pdvmList[0].projectIdName;
          items = pdvmList.map((pdvm) {
            return DropdownMenuItem(value: pdvm.projectIdName, child: Text(pdvm.projectIdName!));
          }).toList();
        });
      },
    );
  }

  DropdownButton<Object> projectDropDown() {
    return DropdownButton(
      value: projectSelected,
      isDense: true,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      items: items,
      onChanged: (selectedItem) {
        setState(() {
          projectSelected = selectedItem;
        });
      },
    );
  }

  selectDate(BuildContext context) async {
    final DateTime? d =
        await showDatePicker(context: context, initialDate: widget.tsModel.selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2030));

    setState(() {
      widget.tsModel.selectedDate = d!.toUtc();
      debugPrint('InsertUpdateTimeSheet - dtoUTC: $widget.tsModel.selectedDate');
    });
    //return d;
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? t = await showTimePicker(context: context, initialTime: widget.tsModel.startTime);
    debugPrint('InsertUpdateTimeSheet - t: $t');
    if (t != null) {
      setState(() {
        widget.tsModel.startTime = t;
        debugPrint('InsertUpdateTimeSheet - ST: ${widget.tsModel.startTime}');
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? t = await showTimePicker(context: context, initialTime: widget.tsModel.endTime);
    debugPrint('InsertUpdateTimeSheet - t: $t');
    if (t != null) {
      setState(() {
        //tsModel.endTime = t.format(context);
        widget.tsModel.endTime = t;
        debugPrint('InsertUpdateTimeSheet - ET: ${widget.tsModel.endTime}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController workDescriptionTextEditingController = TextEditingController()..text = widget.tsModel.workDescription;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //toolbarHeight: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
        ),
        title: Text(widget.tsModel.objectId == "" ? "Enter Timesheet" : "Update Timesheet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 8, 0, 0),
                  child: Text('Project:    ', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                //(widget.tsModel.id == null) ?  projectDropDown() : Text('${widget.tsModel.projectId}'),
                projectDropDown(),
              ],
            ),
            const Padding(padding: EdgeInsets.fromLTRB(12.0, 8, 0, 0)),
            Row(
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Colors.blueAccent,
                    ),
                    tooltip: 'Pick a date',
                    onPressed: () => selectDate(context)),
                const Text('Date: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.tsModel.selectedDateStr),
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.access_time, color: Colors.blueAccent),
                    tooltip: 'Pick a Start time',
                    onPressed: () => _selectStartTime(context)),
                const Text('Start Time: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(timeOfDayToString(widget.tsModel.startTime)),
              ],
            ),
            Row(children: [
              IconButton(
                  icon: const Icon(Icons.access_time, color: Colors.blueAccent),
                  tooltip: 'Pick a Start time',
                  onPressed: () => _selectEndTime(context)),
              const Text('End Time: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(timeOfDayToString(widget.tsModel.endTime))
            ]),
            Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
                child: Row(
                  children: const [Text('Work Description:', style: TextStyle(fontWeight: FontWeight.bold))],
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 8, 14.0, 0),
              child: TextFormField(
                  maxLength: 300,
                  maxLines: 5,
                  autofocus: true,
                  controller: workDescriptionTextEditingController,
                  decoration: const InputDecoration(border: OutlineInputBorder())),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8, 0, 0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.tsModel.numberOfHrs = setNumberOfHrs(widget.tsModel.startTime, widget.tsModel.endTime);
                        widget.tsModel.workDescription = workDescriptionTextEditingController.text;
                        widget.tsModel.projectDM = (pdvmList.firstWhere((element) => element.projectIdName == projectSelected)).pdm;

                        debugPrint("InsertUpdateTimeSheet:build tsModel= ${widget.tsModel.objectId}");
                        if (widget.tsModel.objectId == "") {
                          tsRepo.create(widget.tsModel);
                          Navigator.pop(context);
                        } else {
                          tsRepo.update(widget.tsModel);
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => const NavigateMenuTopBar(index: 0)), (route) => false);
                        }
                        //Use PushReplacementNamed method to go back to the root page without back arrow in Appbar.
                        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavigateMenuTopBar(index: 0)), (route) =>false);
                        //Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text(widget.tsModel.objectId == "" ? 'Submit' : 'Update')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if(isNewTimeSheet) {
                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (context) => const NavigateMenuTopBar(index: 0)), (route) => false);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Cancel")),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
