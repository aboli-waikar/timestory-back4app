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
    //print("ProjectRepository:getAll ApiResponse: ${apiResponse.results.toString()}");
    if (apiResponse.success && apiResponse.results != null) {
      List<ProjectDataModel> pdm = apiResponse.results!.map((e) => e as ParseObject).toList().map((po) => pToPoConv.parseObjectToDomain(po)).toList();
      print("ProjectRepository:getAll pdm: ${pdm.toString()}");
      print("ProjectRepository:getAll pdmLength: ${pdm.length.toString()}");
      return pdm.toList();
    }
    return [];
  }

  @override
 Future<ProjectDataModel> getById(String? objectId) async {

    var apiResponse = await ParseObject(_tableName).getObject(objectId!);

    if (apiResponse.success && apiResponse.results != null) {
      var pdm;
      for (var o in apiResponse.results!) {
        final po = o as ParseObject;
        pdm = pToPoConv.parseObjectToDomain(po);
      }
      return pdm;
    }

    return ProjectDataModel.nullObject;
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

  void update(ProjectDataModel t) async {
    await Future.delayed(Duration(seconds: 1), () async {
      print("ProjectRepository:Update Pdm: ${t.toString()}");
      var ppo = pToPoConv.domainToUpdateParseObject(t);
      print("ProjectRepository:Update ppo: ${ppo.toString()}");
      var apiResponse = await ppo.save();
      print("ProjectRepository:Update apiResponse: ${apiResponse.toString()}");
    });
  }

  void delete(ProjectDataModel t) async {
    await Future.delayed(Duration(seconds: 1), () async {
      print("ProjectRepository:Delete Pdm: ${t.toString()}");

      var ppo = pToPoConv.domainToDeleteParseObject(t);
      print("ProjectRepository:Delete ppo: ${ppo.toString()}");

      var apiResponse = await ppo.delete();
      print("ProjectRepository:Update apiResponse: ${apiResponse.toString()}");
    });
  }
}
