import 'package:timestory_back4app/model/Domain.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';

class ProjectDataModel extends Domain {
  @override
  String? objectId;
  UserDataModel userDM;
  num projectId;
  String name;
  String company;
  num hourlyRate;
  String currency;


  ProjectDataModel(this.objectId, this.userDM, this.projectId, this.name, this.company, this.hourlyRate, this.currency);

  ProjectDataModel.onlyId(String objectId) : this(objectId, UserDataModel.nullObject, 0, "", "", 0, "");

  //ProjectDataModel.onlyObjectIdUserId(String objectId, UserDataModel userId) : this(objectId, userId, 0, "", "", 0, "");


  static final ProjectDataModel nullObject = ProjectDataModel("", UserDataModel.nullObject, 0, "", "", 0, "");

  @override
  String toString() {
    return "ProjectDataModel($objectId, $userDM, $projectId, $name, $company, $hourlyRate, $currency)";
  }
}
