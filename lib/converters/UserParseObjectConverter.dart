import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/DomainParseObjectConverterInterface.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';

class UserParseObjectConverter implements DomainParseObjectConverterInterface<UserDataModel> {
  final String _tableName = "User";
  final String _className = "_User";

  _setPOProperties(ParseObject po, UserDataModel t) {
    po.set('username', t.username);
    po.set('password', t.password);
    po.set('email', t.email);
    po.set('photoUrl', t.photoUrl);
  }

  @override
  ParseObject domainToNewParseObject(UserDataModel t) {
    var user = ParseObject(_tableName);
    _setPOProperties(user, t);

    print("UserParseObjectConverter Create User: ${user.toString()}");
    return user;
  }

  @override
  ParseObject domainToUpdateParseObject(UserDataModel t) {
    ParseObject user = ParseObject(_tableName)..objectId = t.objectId;
    _setPOProperties(user, t);

    print("UserParseObjectConverter Update User: ${user.toString()}");
    return user;
  }

  @override
  ParseObject domainToDeleteParseObject(UserDataModel t) {
    ParseObject user = ParseObject(_tableName)..objectId = t.objectId;

    print("UserParseObjectConverter Delete User: ${user.toString()}");
    return user;
  }

  @override
  UserDataModel parseObjectToDomain(ParseObject po) {
    var id = po.get('objectId');
    var username = po.get("username");
    var email = po.get("email");
    var password = po.get("password");
    var photoUrl = po.get("photoUrl");
    var user = UserDataModel(id, username, password, email, photoUrl);
    return user;
  }

  /// parseObjectToDomainWithOnlyId returns UserModel and to be used by the model referring to the UserModel objectId ex: ProjectModel
  @override
  UserDataModel parseObjectToDomainIncludeOnlyObjectId(ParseObject po) {
    var id = po.get<String>('objectId');
    var user = UserDataModel.onlyId(id!);
    return user;
  }

  @override
  Map domainToPointerParseObject(UserDataModel udm) {
    Map userMap = {"__type": "Pointer", "className": _className, "objectId": udm.objectId};
    return userMap;
  }

}
