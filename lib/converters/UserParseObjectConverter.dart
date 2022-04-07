import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/DomainParseObjectConverterInterface.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';

class UserParseObjectConverter implements DomainParseObjectConverterInterface<UserDataModel> {
  @override
  final String _tableName = "User";

  @override
  final String _className = "_User";

  @override
  ParseObject domainToNewParseObject(UserDataModel t) {
    var user = ParseObject(_tableName);
    _setPOProperties(user, t);
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

  @override
  UserDataModel parseObjectToDomainWithOnlyId(ParseObject po) {
    var id = po.get<String>('objectId');
    var user = UserDataModel.onlyId(id!);
    return user;
  }

  @override
  Map domainToPointerParseObject(UserDataModel udm) {
    Map userMap = {"__type": "Pointer", "className": _className, "objectId": udm.objectId};
    return userMap;
  }

  // @override
  // void domainToUpdateParseObject(ParseObject po, t) {
  //   _setPOProperties(po, t);
  // }

  _setPOProperties(ParseObject po, UserDataModel t) {
    po.set('username', t.username);
    po.set('password', t.password);
    po.set('email', t.email);
    po.set('photoUrl', t.photoUrl);
  }
}
