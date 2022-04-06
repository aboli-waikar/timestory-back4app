import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/ProjectParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/repositories/Repository.dart';

class ProjectRepository extends Repository<ProjectDataModel> {
  @override
  final String _tableName = "Project";

  var pToPoConv = ProjectParseObjectConverter();

  @override
  Future<List<ProjectDataModel>> getAll() async {
    final apiResponse = await ParseObject(_tableName).getAll();
    print("UserRepository:getAll ApiResponse: ${apiResponse.results.toString()}");
    if (apiResponse.success && apiResponse.results != null) {
      var pns = apiResponse.results!.map((e) => e as ParseObject).toList().map((po) => pToPoConv.parseObjectToDomain(po)).toList();
      print("UserRepository:getAll pns: ${pns.toString()}");
      print("UserRepository:getAll usersLength: ${pns.length.toString()}");
      return pns.toList();
    }
    return [];
  }

  @override
  Future<ProjectDataModel> getById(String objectId) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  void create(ProjectDataModel t) async {
    await Future.delayed(Duration(seconds: 1), () async {
      print("ProjectRepository:Create Pdm: ${t.toString()}");
      var ppo = pToPoConv.domainToNewParseObject(t);
      print("ProjectRepository:Create ppo: ${ppo.toString()}");
      var apiResponse = await ppo.save();
      print("ProjectRepository:Create apiResponse: ${apiResponse.toString()}");
    });
  }
}
