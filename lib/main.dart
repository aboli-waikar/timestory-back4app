import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timestory_back4app/converters/UserParseObjectConverter.dart';
import 'package:timestory_back4app/model/UserDataModel.dart';
import 'package:timestory_back4app/views/PageRoutes.dart';
import 'package:timestory_back4app/views/Login.dart';
import 'package:timestory_back4app/views/TimeSheet.dart';
import 'package:timestory_back4app/views/Expenses.dart';
import 'package:timestory_back4app/views/Profile.dart';
import 'views/SideNavigation.dart';

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
  late UserDataModel timeStoryUser;

  @override
  void initState() {
    initAction();
    super.initState();
  }

  Future<void> initAction() async {
    var uToPoConv = UserParseObjectConverter();
    final parseUser = await ParseUser.currentUser() as ParseUser;
    debugPrint('TimeStoryUser from Main: ${parseUser.username}');
    if (parseUser == null) {
      return;
    } else {
      setState(() {
        isBusy = false;
        isLoggedIn = true;
        timeStoryUser = uToPoConv.parseObjectToDomain(parseUser);
      });
    }
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
                    ? SideNavigationPage(index: 0, timeStoryUser: timeStoryUser,) //NavigateMenuTopBar(index: 0) //NavigateMenus()
                    : const Login(),
          ),
        ),
        routes: {
          PageRoutes.login: (context) => const Login(),
          PageRoutes.home: (context) => TimeSheet(),
          PageRoutes.expenses: (context) => Expenses(),
          PageRoutes.profile: (context) => Profile(),
        });
  }
}
