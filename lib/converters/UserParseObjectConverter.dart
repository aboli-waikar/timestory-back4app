import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/DomainParseObjectConverterInterface.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';

class UserParseObjectConverter implements DomainParseObjectConverterInterface<UserDataModel> {

  @override
  ParseObject domainToNewParseObject(UserDataModel t) {
    var user = ParseObject('User');
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
  UserDataModel parseReference(ParseObject po) {
    var id = po.get<String>('objectId');
    var user = UserDataModel.fromId(id!);
    return user;
  }

  @override
  void updateParseObject(ParseObject po, t) {
    _setPOProperties(po, t);
  }

  _setPOProperties(ParseObject po, UserDataModel t) {
    po.set('username', t.username);
    po.set('password', t.password);
    po.set('email', t.email);
    po.set('photoUrl', t.photoUrl);
  }
}
