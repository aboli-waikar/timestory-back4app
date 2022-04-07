import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/ProjectParseObjectConverter.dart';
import 'package:timestory_back4app/converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/repositories/ProjectRepository.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import 'package:timestory_back4app/views/Profile.dart';

class Projects extends StatefulWidget {
  Projects({Key? key}) : super(key: key);
  static String routeName = '/Project';

  @override
  ProjectsState createState() => ProjectsState();
}

class ProjectsState extends State<Projects> {
  var pToPoConv = ProjectParseObjectConverter();

  var util = Utilities();
  var projRepo = ProjectRepository();
  late Future getProjectData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjectData = getProjectList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async => util.signOut(context),
                child: const Text('SIGN OUT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Profile(),
            Card(
              child: ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Project Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                children: [
                  StreamBuilder<Object>(
                    stream: null,
                    builder: (context, snapshot) {
                      return FutureBuilder(
                        future: getProjectData,
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
                                    title: Text("${snapshot.data[index].projectId} - ${snapshot.data[index].name}"),
                                    visualDensity: const VisualDensity(vertical: -4.0),
                                    trailing: Container(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () async {
                                              var pdm = snapshot.data[index];
                                              debugPrint("Projects:build pdm= ${pdm.toString()}");
                                              var maxProjectId = getMaxProjectId(snapshot.data);
                                              showProjectDialog(context, pdm, maxProjectId);
                                              //Navigator.pushReplacementNamed(context, '/');
                                            },
                                          ),
                                          IconButton(
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
                                              }
                                              else {
                                                projRepo.delete(snapshot.data[index]);
                                                setState(() {
                                                  snapshot.data.removeAt(index);
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => {},
                                  );
                                });
                          }
                        },

                      );
                    }
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<List<ProjectDataModel>> getProjectList() async {
  var projRepo = ProjectRepository();
  List<ProjectDataModel> projectList = await projRepo.getAll();
  return projectList;
}

getMaxProjectId(List<ProjectDataModel> pdmList){
  var projectIdList = pdmList.map((e) => e.projectId).toList();
  var maxProjectId = projectIdList.reduce(max);
  debugPrint("Projects:getProjectList maxProjectId: $maxProjectId");
  return maxProjectId;
}

showProjectDialog(BuildContext context, ProjectDataModel pdm, maxProjectId) {
  var projRepo = ProjectRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var hourlyrate;
  TextEditingController projectIdController = TextEditingController()
    ..text = (pdm.projectId == 0) ? (maxProjectId + 1).toString() : pdm.projectId.toString();
  TextEditingController projectNameController = TextEditingController()..text = pdm.name;
  TextEditingController projectCompanyController = TextEditingController()..text = pdm.company;
  TextEditingController projectHourlyRateController = TextEditingController()..text = pdm.hourlyRate.toString();
  TextEditingController projectCurrencyController = TextEditingController()..text = pdm.currency;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: (pdm.objectId == "") ? const Text('Add Project') : const Text('Update Project'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: projectIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Project Id'),
                ),
                TextFormField(
                  controller: projectNameController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                ),
                TextFormField(
                  controller: projectCompanyController,
                  decoration: const InputDecoration(labelText: 'Company Name'),
                ),
                TextFormField(
                  controller: projectHourlyRateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Hoate'),
                  onChanged: (value) => (hourlyrate = num.parse(value)),
                ),
                TextFormField(
                  controller: projectCurrencyController,
                  decoration: const InputDecoration(labelText: 'Currency'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final timeStoryUser = await ParseUser.currentUser() as ParseUser;
                            var uPoConv = UserParseObjectConverter();
                            var udm = uPoConv.parseObjectToDomain(timeStoryUser);

                            var pdmChange = ProjectDataModel(pdm.objectId, udm, num.parse(projectIdController.text), projectNameController.text,
                                projectCompanyController.text, num.parse(projectHourlyRateController.text), projectCurrencyController.text);
                            debugPrint("Projects:showProjectDialog pdm= ${pdmChange.toString()}");

                            (pdm.objectId == "") ? projRepo.create(pdmChange) : projRepo.update(pdmChange);

                            Navigator.pop(context);
                            Navigator.pushNamed(context, Projects.routeName);
                            // Navigator.pushAndRemoveUntil(
                            //     context, MaterialPageRoute(builder: (context) => NavigateMenuTopBar(index: 3)), (route) => false);
                          }
                        },
                        child: (pdm.objectId == "") ? const Text('ADD') : const Text('UPDATE')),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
