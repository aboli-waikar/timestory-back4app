import 'package:timestory_back4app/model/Domain.dart';

class UserDataModel extends Domain {

  @override
  String? objectId;
  String username;
  String email;
  String? password;
  String photoUrl;

  UserDataModel.onlyId(String objectId): this(objectId, "", "", "", "");

  UserDataModel(this.objectId, this.username, this.password, this.email, this.photoUrl);

  static final UserDataModel nullObject = UserDataModel("", "", "", "", "");

  @override
  String toString() {
    return "UserDataModel($objectId, $username, $password, $email, $photoUrl)";
  }
}