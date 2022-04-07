import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:timestory_back4app/converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'Projects.dart';

//const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Profile extends StatefulWidget {
  static String routeName = '/Profile';

  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var isLoggedIn = true;
  var picture = const CircleAvatar(backgroundColor: Colors.brown, child: Text('TS', style: TextStyle(fontSize: 22)), maxRadius: 35);
  var imgUrl = "";
  var name = "";
  var email = "";
  var util = Utilities();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    var uToPoConv = UserParseObjectConverter();
    final timeStoryUser = await ParseUser.currentUser() as ParseUser;
    debugPrint("Profile - $timeStoryUser");
    UserDataModel x = uToPoConv.parseObjectToDomain(timeStoryUser); //Not getting user values here
    debugPrint("Profile - Username - ${x.username}");

    setState(() {
      isLoggedIn = true;
      imgUrl = x.photoUrl;

      name = x.username;
      email = x.email;
      debugPrint("Profile - Email: $email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imgUrl)), shape: BoxShape.circle,),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 237,
                  child: ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    visualDensity: const VisualDensity(vertical: -4.0),
                    subtitle: Text(email),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}


// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: PreferredSize(
//         preferredSize: Size(MediaQuery.of(context).size.width, 70),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             TextButton(
//               onPressed: () async => util.signOut(context),
//               child: const Text('SIGN OUT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//             ),
//           ],
//         )),
//     body: SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Card(
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
//                     child: Container(
//                       height: 90,
//                       width: 90,
//                       decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imgUrl)), shape: BoxShape.circle, ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         width: 237,
//                         child: ListTile(
//                           title: Text(
//                             name,
//                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           visualDensity: const VisualDensity(vertical: -4.0),
//                           subtitle: Text(email),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//           Card(
//             child: Projects(),
//           )
//         ],
//       ),
//     ),
//   );
// }


