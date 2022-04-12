import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/viewModels/ProjectDataViewModel.dart';

class TimeSheetViewModel {
  bool isDelete;
  TimeSheetDataModel tsModel;
  ProjectDataViewModel pdvModel;

  TimeSheetViewModel(this.tsModel, this.pdvModel, this.isDelete);
  @override
  toString(){
    return "TimeSheetViewModel($tsModel, $pdvModel, $isDelete)";
  }

}