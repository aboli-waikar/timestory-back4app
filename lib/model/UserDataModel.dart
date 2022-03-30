import 'package:timestory_back4app/model/Domain.dart';

class UserDataModel extends Domain {

  @override
  final String? objectId;
  final String username;
  final String email;
  final String? password;
  final String photoUrl;

  UserDataModel.fromId(String objectId): this(objectId, "", "", "", "");

  UserDataModel(this.objectId, this.username, this.password, this.email, this.photoUrl);

  static final UserDataModel nullObject = UserDataModel("", "", "", "", "");

  @override
  String toString() {
    return "UserDataModel($objectId, $username, $password, $email, $photoUrl)";
  }
}