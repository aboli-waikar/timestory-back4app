import 'package:timestory_back4app/model/Domain.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';

class ProjectDataModel extends Domain {
  @override
  final String? objectId;
  final UserDataModel userDM;
  final num projectId;
  final String name;
  final String company;
  final num hourlyRate;
  final String currency;


  ProjectDataModel(this.objectId, this.userDM, this.projectId, this.name, this.company, this.hourlyRate, this.currency);

  ProjectDataModel.onlyObjectIdUserId(String objectId, UserDataModel userId) : this(objectId, userId, 0, "", "", 0, "");

  static final ProjectDataModel nullObject = ProjectDataModel("", UserDataModel.nullObject, 0, "", "", 0, "");

  @override
  String toString() {
    return "ProjectDataModel($objectId, $userDM, $projectId, $name, $company, $hourlyRate, $currency)";
  }
}
