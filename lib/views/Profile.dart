import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
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
  var imgUrl ="";
  var name = "";
  var email = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    final timeStoryUser = await ParseUser.currentUser() as ParseUser;
    setState(() {
      isLoggedIn = true;
      imgUrl = timeStoryUser.get("photoUrl");
      name = timeStoryUser.get("username");
      email = timeStoryUser.get("email");
      debugPrint(email);
    });
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
                onPressed: () async {
                  signOut(context);
                },
                child: const Text('SIGN OUT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imgUrl)), shape: BoxShape.circle, ),
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
                )),
            Card(
              child: Projects(),
            )
          ],
        ),
      ),
    );
  }
}
