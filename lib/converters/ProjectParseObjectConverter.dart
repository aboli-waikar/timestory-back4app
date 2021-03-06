import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/DomainParseObjectConverterInterface.dart';
import 'package:timestory_back4app/converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';

import '../model/UserDataModel.dart';

class ProjectParseObjectConverter implements DomainParseObjectConverterInterface<ProjectDataModel> {
  final String _tableName = "Project";
  final String _className = "Project";

  UserParseObjectConverter uToPoConv = UserParseObjectConverter();

  _setPOProperties(ParseObject po, ProjectDataModel t) {
    var userMap = uToPoConv.domainToPointerParseObject(t.userDM);

    po.set('userId', userMap);
    po.set('projectId', t.projectId);
    po.set('name', t.name);
    po.set('company', t.company);
    po.set('hourlyRate', t.hourlyRate);
    po.set('currency', t.currency);
  }

  @override
  ParseObject domainToNewParseObject(ProjectDataModel t) {
    var project = ParseObject(_tableName);
    _setPOProperties(project, t);
    print("ProjectParseObjectConverter New Project: ${project.toString()}");
    return project;
  }

  @override
  domainToUpdateParseObject(ProjectDataModel t) {
    ParseObject project = ParseObject(_tableName)..objectId = t.objectId;
    _setPOProperties(project, t);

    print("ProjectParseObjectConverter Update Project: ${project.toString()}");
    return project;
  }

  @override
  ParseObject domainToDeleteParseObject(t) {
    ParseObject project = ParseObject(_tableName)..objectId = t.objectId;

    print("ProjectParseObjectConverter Delete Project: ${project.toString()}");
    return project;
  }

  @override
  parseObjectToDomain(ParseObject po) {
    var objectId = po.get<String>('objectId');
    var name = po.get<String>('name');
    var company = po.get<String>('company');
    var hourlyRate = po.get<num>('hourlyRate');
    var currency = po.get<String>('currency');
    var projectId = po.get<num>('projectId');
    ParseUser? parseUser = po.get<ParseUser>('userId');
    UserDataModel udm = uToPoConv.parseObjectToDomainIncludeOnlyObjectId(parseUser!); // UserDataModel with only Object Id
    var project = ProjectDataModel(objectId, udm, projectId!, name!, company!, hourlyRate!, currency!);
    //print("ProjectParseObjectConverter project: ${project.toString()}");
    return project;
  }

  @override
  ProjectDataModel parseObjectToDomainIncludeOnlyObjectId(ParseObject po) {
    var objectId = po.get<String>('objectId');
    var project = ProjectDataModel.onlyId(objectId!);
    return project;
  }

  @override
  Map domainToPointerParseObject(ProjectDataModel t) {
    Map projectMap = {"__type": "Pointer", "className": _className, "objectId": t.objectId};
    return projectMap;
  }
}
