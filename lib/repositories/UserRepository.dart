import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';
import 'package:timestory_back4app/repositories/Repository.dart';

class UserRepository extends Repository<UserDataModel> {
  @override
  final String _tableName = "User";

  var uToPoConv = UserParseObjectConverter();

  @override
  Future<List<UserDataModel>> getAll() async {
    final apiResponse = await ParseObject(_tableName).getAll();
    print("UserRepository:getAll ApiResponse: ${apiResponse.results.toString()}");
    if (apiResponse.success && apiResponse.results != null) {
      var users = apiResponse.results!.map((e) => e as ParseObject).toList().map((po) => uToPoConv.parseObjectToDomain(po)).toList();
      print("UserRepository:getAll users: ${users.toString()}");
      print("UserRepository:getAll usersLength: ${users.length.toString()}");
      return users.toList();
    }
    return [];
  }

  @override
  Future<UserDataModel> getById(String objectId) async {
    var apiResponse = await ParseObject(_tableName).getObject(objectId);

    if (apiResponse.success && apiResponse.results != null) {
      var udm;
      for (var o in apiResponse.results!) {
        final po = o as ParseObject;
        udm = uToPoConv.parseObjectToDomain(po);
      }
      return udm;
    }

    return UserDataModel.nullObject;
  }

  @override
  void create(UserDataModel t) {
    // TODO: implement create
  }

  @override
  void update(UserDataModel t) {
    // TODO: implement update
  }

  @override
  void delete(UserDataModel t) {
    // TODO: implement delete
  }
}
