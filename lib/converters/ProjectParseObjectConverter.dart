import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/DomainParseObjectConverterInterface.dart';
import 'package:timestory_back4app/converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';

import '../model/UserDataModel.dart';

class ProjectParseObjectConverter implements DomainParseObjectConverterInterface<ProjectDataModel> {

  @override
  ParseObject domainToNewParseObject(ProjectDataModel t) {
    var project = ParseObject('Project');
    _setPOProperties(project, t);
    return project;
  }

  @override
  ProjectDataModel parseObjectToDomain(ParseObject po) {
    var objectId = po.get<String>('objectId');
    var name = po.get<String>('name');
    var company = po.get<String>('company');
    var hourlyRate = po.get<num>('hourlyRate');
    var currency = po.get<String>('currency');
    var projectId = po.get<num>('projectId');
    print(projectId);


    ParseUser? parseUser = po.get<ParseUser>('userId');
    var uToPoConv = UserParseObjectConverter();
    UserDataModel user =  uToPoConv.parseReference(parseUser!);
    print(user.toString());

    var project = ProjectDataModel(objectId, user.objectId!, projectId!, name!, company!, hourlyRate!, currency!);
    print("project: ${project.toString()}");
    return project;
  }

  @override
  ProjectDataModel parseReference(ParseObject po) {
    var objectId = po.get<String>('objectId');
    var project = ProjectDataModel.fromId(objectId!);
    return project;
  }

  @override
  void updateParseObject(ParseObject po, ProjectDataModel t) {
    _setPOProperties(po, t);
  }

  _setPOProperties(ParseObject po, ProjectDataModel t) {
    // (ParseObject('User')..objectId = t.userId).toPointer());
    po.set('userId', (ParseObject('User')..objectId = t.userId).toPointer());
    po.set('projectId', t.projectId);
    po.set('name', t.name);
    po.set('company', t.company);
    po.set('hourlyRate', t.hourlyRate);
    po.set('currency', t.currency);
  }
}
