import 'package:flutter/material.dart';
import 'package:timestory_back4app/model/Domain.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';

class TimeSheetDataModel extends Domain{

  @override
  final String? objectId;
  final ProjectDataModel projectDM;
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String workDescription;
  final num numberOfHrs;

  TimeSheetDataModel(this.objectId, this.projectDM, this.selectedDate, this.startTime, this.endTime, this.workDescription, this.numberOfHrs);

  static final nullObjects = TimeSheetDataModel("",ProjectDataModel.nullObject, DateTime.now(), TimeOfDay.now(), TimeOfDay.now(), "",0.0);

  TimeSheetDataModel.onlyObjectIdProjectId(String objectId, ProjectDataModel projectDM): this(objectId, projectDM, DateTime.now(), TimeOfDay.now(),
      TimeOfDay.now(), "",0.0); //constructor overloading

  @override
  toString(){
    return "TimeSheetDataModel($objectId, $projectDM, $selectedDate, $startTime, $endTime, $workDescription, $numberOfHrs)";
  }



}