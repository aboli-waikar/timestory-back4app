import 'dart:core';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/ProjectParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import '../converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/util/Utilities.dart';

class Projects extends StatefulWidget {
  Projects({Key? key}) : super(key: key);

  @override
  ProjectsState createState() => ProjectsState();

  var pToPoConv = ProjectParseObjectConverter();

  Future<String?>? getUser() async {
    var uToPoConv = UserParseObjectConverter();
    final timeStoryUser = await ParseUser.currentUser() as ParseUser;
    var user = uToPoConv.parseObjectToDomain(timeStoryUser);
    var userid = user.objectId;
    return userid;
  }

  void addProject(ProjectDataModel pdmReceived) async {
    debugPrint("In Add Project");
    String? userId = await getUser();
    ProjectDataModel pdm = ProjectDataModel("", userId!, pdmReceived.projectId, pdmReceived.name, pdmReceived.company, pdmReceived.hourlyRate,
        pdmReceived.currency);
    debugPrint("Pdm: ${pdm.toString()}");
    // ParseObject ppo = pToPoConv.domainToNewParseObject(pdm);

    var ppo = ParseObject('Project')
    ..set('objectId',"")
    ..set('userId', (ParseObject('User')..objectId = userId).toPointer())
    ..set('projectId', pdm.projectId)
    ..set('name', pdm.name)
    ..set('company', pdm.company)
    ..set('hourlyRate', pdm.hourlyRate)
    ..set('currency', pdm.currency);
    debugPrint("ppo: ${ppo.toString()}");
    await ppo.save();

    //debugPrint("Add Project ApiResponse: ${apiResponse.results.toString()}");
    //return apiResponse;
    //if(apiResponse.success && apiResponse.results != null){
    // if (apiResponse.success) {
    //   var message = "Project successfully created.";
    //   util.showMessage(context, message);
    //   return apiResponse.results;
    // } else {
    //   var message = apiResponse.error!.message;
    //   util.showMessage(context, message);
    // }
  }
}

class ProjectsState extends State<Projects> {
  var pToPoConv = ProjectParseObjectConverter();

  var util = Utilities();

  // getUser() async {
  //   var uToPoConv = UserParseObjectConverter();
  //   final timeStoryUser = await ParseUser.currentUser() as ParseUser;
  //   var user = uToPoConv.parseObjectToDomain(timeStoryUser);
  //   var userid = user.objectId;
  //   return userid;
  // }

  getProject() async {
    final apiResponse = await ParseObject('Project').getAll();
    debugPrint("Projects ApiResponse: ${apiResponse.results.toString()}");
    if (apiResponse.success && apiResponse.results != null) {
      var pns = apiResponse.results!.map((e) => e as ParseObject).toList().map((po) => pToPoConv.parseObjectToDomain(po)).toList().map((p) => p.name);
      debugPrint(pns.toString());
      debugPrint(pns.length.toString());
      return pns.toList();
    }
    return [];
  }

  // addProject(num id, String name, String company, num rate, String currency) async {
  //   var userid = getUser();
  //   var pdm = ProjectDataModel("", userid, id, name, company, rate, currency);
  //   var ppo = pToPoConv.domainToNewParseObject(pdm);
  //   ParseResponse apiResponse = await ppo.save();
  //   //if(apiResponse.success && apiResponse.results != null){
  //   if (apiResponse.success) {
  //     var message = "Project successfully created.";
  //     util.showMessage(context, message);
  //     return apiResponse.results;
  //   } else {
  //     var message = apiResponse.error!.message;
  //     util.showMessage(context, message);
  //   }
  // }

  editProject() {}

  deleteProject() {}

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text(
        'Project Information',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        FutureBuilder(
          future: getProject(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text("Loading"),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(snapshot.data[index]),
                        visualDensity: const VisualDensity(vertical: -4.0),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            if (snapshot.data[index] == 1) {
                              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Project can not be deleted")));
                              return showDialog(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(title: const Text("Project can not be deleted.", style: TextStyle(fontSize: 14)), actions: [
                                        ElevatedButton.icon(
                                          onPressed: () => Navigator.pop(context),
                                          icon: const Icon(Icons.close_rounded),
                                          label: const Text("Close"),
                                        ),
                                      ]));
                            } else {
                              //deleteProject(snapshot.data[index].id);
                            }
                            Navigator.pushReplacementNamed(context, '/');
                          },
                        ),
                        onTap: editProject() //edit the project,
                        );
                  });
            }
          },
        )
      ],
    );
  }
}
