import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timestory_back4app/model/Domain.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';

class TimeSheetDataModel extends Domain{

  @override
  String? objectId;
  ProjectDataModel projectDM;
  DateTime selectedDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String workDescription;
  num numberOfHrs;

  TimeSheetDataModel(this.objectId, this.projectDM, this.selectedDate, this.startTime, this.endTime, this.workDescription, this.numberOfHrs);

  static final nullObjects = TimeSheetDataModel("",ProjectDataModel.nullObject, DateTime.now(), TimeOfDay.now(), TimeOfDay.now(), "",0.0);

  TimeSheetDataModel.onlyObjectIdProjectId(String objectId, ProjectDataModel projectDM): this(objectId, projectDM, DateTime.now(), TimeOfDay.now(),
      TimeOfDay.now(), "",0.0); //constructor overloading

  String get selectedDateStr {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    var toFormat = (this.selectedDate == null) ? DateTime.now() : this.selectedDate;
    return formatter.format(toFormat);
  }

  @override
  toString(){
    return "TimeSheetDataModel($objectId, $projectDM, $selectedDate, $startTime, $endTime, $workDescription, $numberOfHrs)";
  }

}