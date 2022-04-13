import 'package:timestory_back4app/model/TimeSheetDataModel.dart';

class TimeSheetViewModel {
  bool isDelete;
  TimeSheetDataModel tsModel;

  TimeSheetViewModel(this.tsModel, this.isDelete);
  @override
  toString(){
    return "TimeSheetViewModel($tsModel, $isDelete)";
  }

}