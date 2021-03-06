// import 'package:flutter/material.dart';
// import 'TimeSheet.dart';
// import 'ReadTimeSheet.dart';
// import 'Expenses.dart';
// import 'Projects.dart';
// import 'Profile.dart';
//
//
// class NavigateMenus extends StatefulWidget {
//   const NavigateMenus({Key? key}) : super(key: key);
//
//   @override
//   _NavigateMenusState createState() => _NavigateMenusState();
// }
//
// class _NavigateMenusState extends State<NavigateMenus> {
//   int _selectedIndex = 0;
//   bool isBusy = false;
//   bool isLoggedIn = false;
//
//   void onTapped(int value) {
//     setState(() {
//       _selectedIndex = value;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List _widgetClasses = [
//       Home(),
//       ReadTimeSheet(),
//       Home(),
//       Expenses(),
//       Profile(),
//     ];
//     return MaterialApp(
//       title: 'TimeSheet',
//       home: Scaffold(
//         body: Center(child: _widgetClasses.elementAt(_selectedIndex)),
//         bottomNavigationBar: BottomNavigationBar(
//           iconSize: 40.0,
//           showUnselectedLabels: true,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.green,
//           selectedFontSize: 14,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.brown), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.update, color: Colors.brown), label: 'TimeSheet'),
//             BottomNavigationBarItem(icon: Icon(Icons.add_circle, color: Colors.white), label: ' '),
//             BottomNavigationBarItem(icon: Icon(Icons.money_outlined, color: Colors.brown), label: 'Expenses'),
//             BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.brown), label: 'Profile'),
//           ],
//           currentIndex: _selectedIndex,
//           onTap: onTapped,
//         ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.deepOrange,
//           child: const Icon(
//             Icons.add,
//             color: Colors.white,
//             size: 50.0,
//           ),
//           onPressed: () => showSheet(),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       ),
//     );
//   }
//
//   showSheet() {
//     var pr = ProjectsState();
//     showModalBottomSheet(
//       useRootNavigator: true,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20.0),
//             topRight: Radius.circular(20.0),
//           )),
//       context: context,
//       builder: (context) {
//         return SingleChildScrollView(
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               children: [
//                 Card(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text("Timesheet", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
//                       const Divider(height: 2.0, color: Colors.black),
//                       Row(
//                         children: [
//                           SizedBox(
//                             //color: Colors.deepOrange,
//                               height: 100,
//                               width: 100,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: ElevatedButton(
//                                     child: Image.asset("images/CreateTimeSheet.png", height: 100, width: 100, alignment: Alignment.center),
//                                     onPressed: () {
//                                       //Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
//                                       Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
//
//                                     }),
//                               )),
//                           SizedBox(
//                             //color: Colors.deepOrange,
//                               height: 100,
//                               width: 100,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: ElevatedButton(
//                                     child: Image.asset("images/StartTimer.png", height: 100, width: 100, alignment: Alignment.center),
//                                     onPressed: () {
//                                       //Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateTimeSheet.defaultModel()));
//                                       Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
//
//                                     }),
//                               )),
//                         ],
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text("Project", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
//                       ),
//                       const Divider(height: 2.0, color: Colors.black),
//                       Row(
//                         children: [
//                           SizedBox(
//                             //color: Colors.deepOrange,
//                               height: 100,
//                               width: 100,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: ElevatedButton(
//                                   child: Image.asset("images/CreateProject.png", height: 100, width: 100, alignment: Alignment.center),
//                                   onPressed: () {
//                                     pr.showProjectDialog(context);
//                                   },
//                                 ),
//                               )),
//                         ],
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 40.0),
//                         child: Divider(height: 2.0, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }




// print("po: $po");
// var id = po.get('objectId');
// print(id);
//
// QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject('User'));
// parseQuery.whereContains('objectId', id);
//
// var apiResponse = await parseQuery.query();
//
// {"className":"Project","name":"P2","company":"W","hourlyRate":100,"currency":"","userId":"WES1YmOLae","projectId":2}
//
//
// [{"className":"Project","objectId":"hFIxIuqd6p","createdAt":"2022-03-29T15:31:57.671Z","updatedAt":"2022-03-30T16:42:44.501Z","userId":{"__type":"Pointer","className":"_User","objectId":
// "WES1YmOLae"},"projectId":1,"name":"Microgrid","company":"Codionics","hourlyRate":1400,"currency":"INR"}]
//
//
// {"className":"Project","userId":{"__type":"Pointer","className":"User","objectId":"WES1YmOLae"},"projectId":2,"name":"P2","company":"C2","hourlyRate":100,"currency":"INR"}
//
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