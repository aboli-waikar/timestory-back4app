import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/DomainParseObjectConverterInterface.dart';
import 'package:timestory_back4app/converters/ProjectParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/model/TimeSheetDataModel.dart';

class TimeSheetParseObjectConverter implements DomainParseObjectConverterInterface<TimeSheetDataModel> {
  final String _tableName = 'TimeSheet';
  final String _className = '_TimeSheet';

  var pToPoConv = ProjectParseObjectConverter();

  void _setPoProperties(ParseObject po, TimeSheetDataModel t) {
    var projectMap = pToPoConv.domainToPointerParseObject(t.projectDM);
    po.set('projectId', projectMap);
    po.set('selectedDate', t.selectedDate);
    po.set('startTime', t.startTime);
    po.set('endTime', t.endTime);
    po.set('workDescription', t.workDescription);
    po.set('numberOfHrs', t.numberOfHrs);
  }


  @override
  ParseObject domainToNewParseObject(TimeSheetDataModel t) {
    var timeSheet = ParseObject(_tableName);
    _setPoProperties(timeSheet, t);
    return timeSheet;
  }

  @override
  Map domainToPointerParseObject(TimeSheetDataModel t) {
    Map timeSheetMap = {"__type":"Pointer","className":_className,"objectId":t.objectId};
    return timeSheetMap;
  }

  @override
  parseObjectToDomain(ParseObject po) {
    var objectId = po.get<String>('objectId');

    var projectPo = po.get<ParseObject>('projectId');
    ProjectDataModel pdm = pToPoConv.parseObjectToDomainWithOnlyId(projectPo!);

    var selectedDate = po.get<DateTime>('selectedDate');
    var startTime = po.get<TimeOfDay>('startTime');
    var endTime = po.get<TimeOfDay>('endTime');
    var workDescription = po.get<String>('workDescription');
    var numberOfHrs = po.get<num>('numberOfHrs');
    return TimeSheetDataModel(objectId, pdm, selectedDate!, startTime!, endTime!, workDescription!, numberOfHrs!);
  }

  ///parseObjectToDomainWithOnlyId returns TimeSheetDataModel and written to be used by the model referring to TimeSheet objectId
  @override
  TimeSheetDataModel parseObjectToDomainWithOnlyId(ParseObject po) {
    var objectId = po.get('objectId');
    var projectId = po.get('projectId');
    ProjectDataModel pdm = pToPoConv.parseObjectToDomainWithOnlyId(projectId);
    var timeSheet = TimeSheetDataModel.onlyObjectIdProjectId(objectId, pdm);
    return timeSheet;
  }

}