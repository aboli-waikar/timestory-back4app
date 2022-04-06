import 'dart:core';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/ProjectParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/repositories/ProjectRepository.dart';
import 'package:timestory_back4app/util/Utilities.dart';

class Projects extends StatefulWidget {
  Projects({Key? key}) : super(key: key);

  @override
  ProjectsState createState() => ProjectsState();

  var pToPoConv = ProjectParseObjectConverter();
  var projRepo = ProjectRepository();

  Future<List<String>> getProjectList() async {
    List<ProjectDataModel> projectList = await projRepo.getAll();
    return projectList.map((project) => project.name).toList();
  }
}

class ProjectsState extends State<Projects> {
  var pToPoConv = ProjectParseObjectConverter();

  var util = Utilities();

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
          future: widget.getProjectList(),
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
