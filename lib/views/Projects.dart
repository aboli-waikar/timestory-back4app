import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/ProjectToParseObjectConverter.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import 'dart:core';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  ProjectsState createState() => ProjectsState();
}

class ProjectsState extends State<Projects> {

  var pToPoConv = ProjectToParseObjectConverter();

  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectCompanyController = TextEditingController();
  TextEditingController projectHourlyRateController = TextEditingController();

  //
  // @override
  // initState() {
  //   super.initState();
  // }

  getProject() async {
    final apiResponse = await ParseObject('Project').getAll();
    debugPrint("ApiResponse: ${apiResponse.results.toString()}");
    debugPrint("Project - getProject()");

    if (apiResponse.success && apiResponse.results != null) {
      // var pl = apiResponse.results!.map((e) => e as ParseObject).toList().map((po) => pToPoConv.fromParseObject(po)).toList().map((p) => p.name);
      var pns = apiResponse.results!.map((e) => e as ParseObject).toList().map((po) => pToPoConv.fromParseObject(po)).toList().map((p) => p.name);
      debugPrint(pns.toString());
      debugPrint(pns.length.toString());
      return pns.toList();
      // for (var o in apiResponse.results!) {
      //   final project = o as ParseObject;
      //   projectList.add(project);
      // }
    }

    return [];
  }

  addProject(String name, String company, num rate, String currency) async {
    final timeStoryUser = await ParseUser.currentUser() as ParseUser;
    var userid = timeStoryUser.get('objectId');

    var project = ParseObject('Project');
    project.set('name', name);
    project.set('company', company);
    project.set('hourlyRate', rate);
    project.set('currency', currency);
    project.set('userId', userid);
    project.save();
  }

  editProject() {}

  deleteProject() {}

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          addProject(projectNameController.text, projectCompanyController.text, hourlyrate, 'INR');
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
