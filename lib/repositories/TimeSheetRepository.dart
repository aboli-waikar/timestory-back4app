import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/TimeSheetParseObjectConverter.dart';
import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/repositories/Repository.dart';

class TimeSheetRepository extends Repository<TimeSheetDataModel> {

  var tsToPoConv = TimeSheetParseObjectConverter();

  @override
  void create(TimeSheetDataModel t) async {
    print("TimeSheetRepository:Create t: ${t.toString()}");

    await Future.delayed(Duration(seconds: 1), () async {
      var tsPo = tsToPoConv.domainToNewParseObject(t);
      print("TimeSheetRepository:Create tsPo: ${tsPo.toString()}");

      var apiResponse = tsPo.save();
      print("TimeSheetRepository:Create apiResponse: ${apiResponse.toString()}");
    }
    );
  }

  @override
  void delete(TimeSheetDataModel t) async {
    await Future.delayed(Duration(seconds: 1), () async {
      var tsPo = tsToPoConv.domainToDeleteParseObject(t);
      print("TimeSheetRepository:Delete tsPo: ${tsPo.toString()}");

      var apiResponse = tsPo.delete();
      print("TimeSheetRepository:Delete apiResponse: ${apiResponse.toString()}");

    });
  }

  @override
  Future<List<TimeSheetDataModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<TimeSheetDataModel> getById(String objectId) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  void update(TimeSheetDataModel t) {
    // TODO: implement update
  }



}