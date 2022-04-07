import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import 'package:timestory_back4app/views/PageRoutes.dart';
import 'package:timestory_back4app/views/NavigateMenus.dart';
import 'package:timestory_back4app/views/Login.dart';
import 'package:timestory_back4app/views/Home.dart';
import 'package:timestory_back4app/views/ReadTimeSheet.dart';
import 'package:timestory_back4app/views/Expenses.dart';
import 'package:timestory_back4app/views/Profile.dart';

//http:localhost:5000

//const secureStorage = FlutterSecureStorage();

void main() async {
  const keyApplicationId = "NlPHrKFNMM8jUIM3A48yxGB3pQghhPOOrwC7xVSZ";
  const keuClientKey = "oRF71shyaQ7sqLP1ZrRti3gK2CbjGvO6xy8ckJL3";
  const parseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, parseServerUrl, clientKey: keuClientKey, autoSendSessionId: true);

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
    final timeStoryUser = await ParseUser.currentUser();
    debugPrint('TimeStoryUser from Main: $timeStoryUser');

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TimeSheet',
        theme: ThemeData(
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
                ),),
          textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold) ),
        ),
        home: Scaffold(
          body: Center(
            child: isBusy
                ? const CircularProgressIndicator()
                : isLoggedIn
                    ? NavigateMenuTopBar(index: 0) //NavigateMenus()
                    : const Login(),
          ),
        ),
        routes: {
          PageRoutes.login: (context) => const Login(),
          PageRoutes.home: (context) => Home(),
          PageRoutes.readTimeSheet: (context) => ReadTimeSheet(),
          PageRoutes.expenses: (context) => Expenses(),
          PageRoutes.profile: (context) => Profile(),
        });
  }
}
