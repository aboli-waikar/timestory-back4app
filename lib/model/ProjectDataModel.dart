import 'package:timestory_back4app/model/Domain.dart';

class ProjectDataModel extends Domain {

  @override
  final String? objectId;
  final String userId;
  final num projectId;
  final String name;
  final String company;
  final num hourlyRate;
  final String currency;

  ProjectDataModel.fromId(String objectId): this(objectId, "", 0, "", "", 0, "");

  ProjectDataModel.withoutObjectIdUserId(String objectId, String userId): this(objectId, userId, 0, "", "", 0, "");

  ProjectDataModel(this.objectId, this.userId, this.projectId, this.name, this.company, this.hourlyRate, this.currency);

  static final ProjectDataModel nullObject = ProjectDataModel("", "", 0, "", "", 0, "");

  @override
  String toString() {
    return "ProjectDataModel($objectId, $userId, $projectId, $name, $company, $hourlyRate, $currency)";
  }
}