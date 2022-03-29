import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/DomainToParseObjectConverter.dart';
import 'package:timestory_back4app/model/Project.dart';

class ProjectToParseObjectConverter implements DomainToParseObjectConverter<Project> {

  @override
  ParseObject fromDomain(Project t) {
    var project = ParseObject('Project');
    project.set('name', t.name);
    project.set('company', t.company);
    project.set('hourlyRate', t.hourlyRate);
    project.set('currency', t.currency);
    project.set('userId', t.userId);
    project.set('projectId', t.projectId);
    return project;
  }

  @override
  Project fromParseObject(ParseObject po) {
    var name = po.get<String>('name');
    var company = po.get<String>('company');
    var hourlyRate = po.get<num>('hourlyRate');
    var currency = po.get<String>('currency');
    var user = po.get<Object>('userId');
    print(user);
    var projectId = po.get<num>('projectId');
    var project = Project(name!, company!, hourlyRate!, currency!, "", projectId!);
    return project;
  }
}
