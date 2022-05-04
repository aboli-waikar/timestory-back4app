import 'package:flutter/material.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'package:timestory_back4app/views/TimeSheet.dart';
import 'package:timestory_back4app/views/InsertUpdateTimeSheet.dart';
import 'package:timestory_back4app/views/Projects.dart';

class QuickAdd extends StatelessWidget {
  QuickAdd({Key? key}) : super(key: key);

  var p = Projects();
  var util = Utilities();

  var _widgetClasses = [
    InsertUpdateTimeSheet.defaultModel(),
    Projects(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepOrange),
        body:
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Card(
                child: SizedBox(
                  //color: Colors.deepOrange,
                    height: 100,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          child: Image.asset("images/CreateTimeSheet.png", height: 100, width: 100, alignment: Alignment.center),
                          onPressed: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
                            _widgetClasses[0];

                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                          }),
                    )),),
              Card(child: SizedBox(
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
                  )),),
              Card(
                child:SizedBox(
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
              ),
            ],
          ),
        ));
  }
}
