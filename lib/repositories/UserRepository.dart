import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';
import 'package:timestory_back4app/repositories/Repository.dart';

class UserRepository extends Repository<UserDataModel> {
  @override
  final String _tableName = "User";

  var uPoConv = UserParseObjectConverter();

  @override
  Future<List<UserDataModel>> getAll() async {
    final apiResponse = await ParseObject(_tableName).getAll();
    print("UserRepository:getAll ApiResponse: ${apiResponse.results.toString()}");
    if (apiResponse.success && apiResponse.results != null) {
      var users = apiResponse.results!.map((e) => e as ParseObject).toList().map((po) => uPoConv.parseObjectToDomain(po)).toList();
      print("UserRepository:getAll users: ${users.toString()}");
      print("UserRepository:getAll usersLength: ${users.length.toString()}");
      return users.toList();
    }
    return [];
  }

  @override
  Future<UserDataModel> getById(String objectId) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  void create(UserDataModel t) {
    // TODO: implement create
  }
}
