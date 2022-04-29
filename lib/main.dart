import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import 'package:timestory_back4app/views/PageRoutes.dart';
import 'package:timestory_back4app/views/NavigateMenus.dart';
import 'package:timestory_back4app/views/Login.dart';
import 'package:timestory_back4app/views/Home.dart';
import 'package:timestory_back4app/views/Expenses.dart';
import 'package:timestory_back4app/views/Profile.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:timestory_back4app/views/Projects.dart';
import 'package:timestory_back4app/views/QuickAdd.dart';

import 'views/NavigationDrawer.dart';

//http:localhost:5000

//const secureStorage = FlutterSecureStorage();

void main() async {
  const keyApplicationId = "NlPHrKFNMM8jUIM3A48yxGB3pQghhPOOrwC7xVSZ";
  const keuClientKey = "oRF71shyaQ7sqLP1ZrRti3gK2CbjGvO6xy8ckJL3";
  const parseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, parseServerUrl, clientKey: keuClientKey, autoSendSessionId: true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(const TimeStoryApp());
}

class TimeStoryApp extends StatefulWidget {
  const TimeStoryApp({Key? key}) : super(key: key);

  @override
  State<TimeStoryApp> createState() => _TimeStoryAppState();
}

class _TimeStoryAppState extends State<TimeStoryApp> {
  bool isBusy = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    initAction();
    super.initState();
  }

  Future<void> initAction() async {
    final timeStoryUser = await ParseUser.currentUser() as ParseUser;
    debugPrint('TimeStoryUser from Main: ${timeStoryUser.username}');

    // final String? storedUIDToken = await secureStorage.read(key: 'uid');
    // debugPrint('From main storedUIDToken: $storedUIDToken');
    if (timeStoryUser == null) {
      return;
    } else {
      setState(() {
        isBusy = false;
        isLoggedIn = true;
      });
    }
  }

  SideNavigationPage() {

    int _currentPageIndex = 0;
    final List _widgetClasses = [
      Home(),
      Expenses(),
      Projects(),
      QuickAdd(),
    ];


    return Row(
      children: [
        SideNavigationBar(
          selectedIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          items: const [
            SideNavigationBarItem(
              icon: Icons.home,
              label: 'Home',
            ),
            SideNavigationBarItem(
              icon: Icons.money_outlined,
              label: 'Expenses',
            ),
            SideNavigationBarItem(
              icon: Icons.home_work,
              label: 'Projects',
            ),
            SideNavigationBarItem(
              icon: Icons.add_circle,
              label: 'Quick Add',
            ),
          ],
        ),
        Expanded(child: _widgetClasses.elementAt(_currentPageIndex),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TimeSheet',
        theme: ThemeData(
          navigationBarTheme: const NavigationBarThemeData(indicatorColor: Colors.green),
          scrollbarTheme: ScrollbarThemeData(thumbColor: MaterialStateProperty.all(Colors.black)),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(fontSize: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(const Size.fromWidth(80)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
              shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        home: Scaffold(
          body: Center(
            child: isBusy
                ? const CircularProgressIndicator()
                : isLoggedIn
                    ? SideNavigationPage() //NavigateMenuTopBar(index: 0) //NavigateMenus()
                    : const Login(),
          ),
        ),
        routes: {
          PageRoutes.login: (context) => const Login(),
          PageRoutes.home: (context) => Home(),
          PageRoutes.expenses: (context) => Expenses(),
          PageRoutes.profile: (context) => Profile(),
        });
  }
}
