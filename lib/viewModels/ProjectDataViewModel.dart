import 'package:timestory_back4app/model/ProjectDataModel.dart';

class ProjectDataViewModel {

  final ProjectDataModel pdm;

  ProjectDataViewModel(this.pdm);

  String? get objectId => pdm.objectId;
  num get projectId => pdm.projectId;
  String? get projectName => pdm.name;
  String? get projectIdName => "$projectId - $projectName";

  @override
  toString() {
    return "ProjectDataViewModel(${pdm.toString()}, $objectId, $projectIdName)";
  }

}