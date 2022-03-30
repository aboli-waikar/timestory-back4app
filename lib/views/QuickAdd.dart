import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/views/Home.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import 'package:timestory_back4app/views/Projects.dart';
import 'package:timestory_back4app/util/Utilities.dart';

class QuickAdd extends StatelessWidget {
  QuickAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Timesheet", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                  const Divider(height: 2.0, color: Colors.black),
                  Row(
                    children: [
                      SizedBox(
                        //color: Colors.deepOrange,
                          height: 100,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                                child: Image.asset("images/CreateTimeSheet.png", height: 100, width: 100, alignment: Alignment.center),
                                onPressed: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

                                }),
                          )),
                      SizedBox(
                        //color: Colors.deepOrange,
                          height: 100,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                                child: Image.asset("images/StartTimer.png", height: 100, width: 100, alignment: Alignment.center),
                                onPressed: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

                                }),
                          )),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Project", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 2.0, color: Colors.black),
                  Row(
                    children: [
                      SizedBox(
                        //color: Colors.deepOrange,
                          height: 100,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              child: Image.asset("images/CreateProject.png", height: 100, width: 100, alignment: Alignment.center),
                              onPressed: () {
                                showProjectDialog(context);
                              },
                            ),
                          )),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 40.0),
                    child: Divider(height: 2.0, color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );;
  }

  var p = Projects();
  var util = Utilities();

  TextEditingController projectIdController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectCompanyController = TextEditingController();
  TextEditingController projectHourlyRateController = TextEditingController();
  TextEditingController projectCurrencyController = TextEditingController();

  showProjectDialog(BuildContext context) {
    num hourlyrate = 100;
    //getProject();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: projectIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Project Id'),
                ),
                TextField(
                  controller: projectNameController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                ),
                TextField(
                  controller: projectCompanyController,
                  decoration: const InputDecoration(labelText: 'Company Name'),
                ),
                TextField(
                  controller: projectHourlyRateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Hourly Rate'),
                  onChanged: (value) => (hourlyrate = num.parse(value)),
                ),
                TextField(
                  controller: projectCurrencyController,
                  decoration: const InputDecoration(labelText: 'Currency'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () async {
                          var pdm = ProjectDataModel("", "", num.parse(projectIdController.text), projectNameController.text,
                              projectCompanyController.text, num.parse(projectHourlyRateController.text), projectCurrencyController.text);
                          p.addProject(pdm);
                          //debugPrint("QuickAdd Project ApiResponse: ${apiResponse.results.toString()}");

                          //if(apiResponse.success && apiResponse.results != null){
                          // if (apiResponse.success) {
                          //   var message = "Project successfully created.";
                          //   util.showMessage(context, message);
                          //   return apiResponse.results;
                          // } else {
                          //   var message = apiResponse.error!.message;
                          //   util.showMessage(context, message);
                          // }

                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (context) => const NavigateMenuTopBar()), (route) => false);
                        },
                        child: const Text('Add Project')),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
