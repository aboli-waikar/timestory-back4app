class ChartViewModel {
  DateTime Date;
  num numberOfHrs;
  String projectIdName;

  ChartViewModel(this.Date, this.numberOfHrs, this.projectIdName);

  @override
  String toString() {
    return "ChartModel($Date, $numberOfHrs, $projectIdName)";
  }

}