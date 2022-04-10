import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/viewModels/ProjectDataViewModel.dart';

class DeleteTimeSheetViewModel {
  bool isDelete;
  TimeSheetDataModel tsModel;
  ProjectDataViewModel pdvModel;

  DeleteTimeSheetViewModel(this.tsModel, this.pdvModel, this.isDelete);
  @override
  toString(){
    return "DeleteTimeSheetViewModel($tsModel, $pdvModel, $isDelete)";
  }

}