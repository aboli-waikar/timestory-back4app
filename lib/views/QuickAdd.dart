import 'package:flutter/material.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'package:timestory_back4app/views/Home.dart';
import 'package:timestory_back4app/views/InsertUpdateTimeSheet.dart';
import 'package:timestory_back4app/views/Projects.dart';

class QuickAdd extends StatelessWidget {
  QuickAdd({Key? key}) : super(key: key);

  var p = Projects();
  var util = Utilities();

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
                      padding: EdgeInsets.all(8.0), child: Text("Timesheet", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
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
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
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
                              onPressed: () async {
                                ProjectDataModel newPdm = ProjectDataModel.nullObject;
                                debugPrint("QuickAdd:build pdm: $newPdm");
                                var projectList = await getProjectList();
                                var maxProjectId = getMaxProjectId(projectList);
                                showProjectDialog(context, newPdm, maxProjectId);
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
    );
    ;
  }
}
