import 'package:flutter/material.dart';
import 'package:timestory_back4app/util/Utilities.dart';
import 'PageRoutes.dart';

class NavigationDrawer extends StatefulWidget {

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {

  var isLoggedIn = true;
  var picture = const CircleAvatar(backgroundColor: Colors.brown, child: Text('TS', style: TextStyle(fontSize: 22)), maxRadius: 35);
  var imgUrl = "";
  var name = "";
  var email = "";
  var util = Utilities();

  getUserDataFromDB() async{
  var x = await getUserData();
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
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
                      child: Container(
                        height: 90,
                        width: 70,
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imgUrl)), shape: BoxShape.circle,),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
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
          ),
          DrawerSimpleMenu(context, Icons.person, "Profile"),
          DrawerExpandedMenu(Icons.art_track, "Configure", ["Milk", "Maid", "Newspaper"]),
          DrawerSimpleMenu(context, Icons.report, "Reports"),
          DrawerSimpleMenu(context, Icons.settings, "Settings"),
          DrawerSimpleMenu(context, Icons.format_list_numbered, "Version 1.0.0"),
        ],
      ),
    );
  }
}

DrawerSimpleMenu(context, IconData icon, String menuName) {
  return InkWell(
    onTap: () {
      debugPrint('$menuName');
      if (menuName == "Profile") Navigator.pushNamed(context, PageRoutes.profile);
      if (menuName == "Home")
        //Navigator.pushNamed(context, PageRoutes.home);
        Navigator.pushReplacementNamed(context, '/');
    },
    splashColor: Colors.orangeAccent,
    child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            menuName,
            style: TextStyle(fontSize: 13.0),
          ),
          dense: true,
        )),
  );
}

DrawerExpandedMenu(IconData icon, String menuName, List subMenuName) {
  return InkWell(
    splashColor: Colors.orangeAccent,
    child: Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
      ),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(
          menuName,
          style: TextStyle(fontSize: 13.0),
        ),
        children: [
          ListView.builder(
            itemCount: subMenuName.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  subMenuName[index],
                  style: TextStyle(fontSize: 12.0),
                ),
                dense: true,
                onTap: () => {},
              );
            },
          ),
        ],
      ),
    ),
  );
}