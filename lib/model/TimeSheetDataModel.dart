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

  String timeOfDayToString(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  toString(){
    return "TimeSheetDataModel($objectId, $projectDM, $selectedDate, $startTime, $endTime, $workDescription, $numberOfHrs)";
  }

}

TimeOfDay stringToTimeOfDay(String ts) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(ts));
}