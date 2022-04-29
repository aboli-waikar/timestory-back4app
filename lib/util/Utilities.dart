import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timestory_back4app/model/ProjectDataModel.dart';
import 'package:timestory_back4app/model/TimeSheetDataModel.dart';
import 'package:timestory_back4app/repositories/ProjectRepository.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import '../converters/UserParseObjectConverter.dart';
import '../main.dart';
import '../model/UserDataModel.dart';
import '../repositories/TimeSheetRepository.dart';

class Utilities {
  var _success=false;
  var googleUser;

  showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (_success == true) ? const Text("Success!") : const Text("Error!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  signUp(BuildContext context, String username, String password, String email) async {
    final timeStoryUser = ParseUser.createUser(username, password, email);
    var response = await timeStoryUser.signUp();
    if (response.success) {
      {
        _success = true;
        showMessage(context, "Registration successful");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavigateMenuTopBar(index: 0)), (route) => false);
      }
    } else {
      _success = false;
      showMessage(context, response.error!.message);
    }
  }

  signIn(BuildContext context, String? username, String password, String? email) async {
    final timeStoryUser = ParseUser(username, password, email);
    var response = await timeStoryUser.login();
    if (response.success) {
      {
        _success = true;
        showMessage(context, "Login successful");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavigateMenuTopBar(index: 0)), (route) => false);
      }
    } else {
      _success = false;
      showMessage(context, response.error!.message);
    }
  }

  signInWithGoogle(BuildContext context) async {
    // Get Google User Credentials using GoogleSignIn()
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    googleUser = await _googleSignIn.signIn();
    debugPrint("GOOGLE USER: $googleUser");

    var googleUserAuth = await googleUser.authentication;
    var accesstoken = await googleUserAuth.accessToken;
    var idtoken = await googleUserAuth.idToken;


    Map<String, String> googleAuthData = {
      "id": googleUser.id,
      "id_token": idtoken,
      "access_token": accesstoken,
      "username": googleUser.displayName,
      "email": googleUser.email,
      "photoUrl": googleUser.photoUrl,
    };

    // Provide Google User Authentication Credentials to back4app
    var response = await ParseUser.loginWith("google", googleAuthData);

    if (response.success) {
      {
        debugPrint("In LoginWith");
        updateGoogleUser(googleAuthData);
        _success = true;
        showMessage(context, "Login successful");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavigateMenuTopBar(index: 0)), (route) => false);
      }
    } else {
      _success = false;
      showMessage(context, response.error!.message);
    }
  }

  signOut(BuildContext context) async {
    final timeStoryUser = await ParseUser.currentUser();
    // await secureStorage.write(key: 'uid', value: null);
    // storedUIDToken = await secureStorage.read(key: 'id');
    var response = await timeStoryUser.logout();
    if (response.success) {
      {
        _success = true;
        showMessage(context, "Logout successful");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TimeStoryApp()), (route) => false);
      }
    } else {
      _success = false;
      showMessage(context, response.error!.message);
    }
  }

  updateGoogleUser(Map googleAuthData) async {
    ParseUser timeStoryUser = await ParseUser.currentUser() as ParseUser;
    timeStoryUser.username = googleAuthData["username"];
    timeStoryUser.emailAddress = googleAuthData["email"];
    timeStoryUser.set("photoUrl", googleAuthData["photoUrl"]);
    await timeStoryUser.save();
  }

}

formatDate(DateTime dt) {
  var formatter = DateFormat('dd-MMM-yyyy');
  return formatter.format(dt);
}


getMonth(DateTime dT) {
  final DateFormat formatter = DateFormat('yyyy-MM');
  var yearMonth = formatter.format(dT);
  return yearMonth;
}

getMonthStr(DateTime dT) {
  final DateFormat formatter = DateFormat('MMM-yyyy');
  var yearMonth = formatter.format(dT);
  return yearMonth;
}

getUserData() async {
  var uToPoConv = UserParseObjectConverter();
  final timeStoryUser = await ParseUser.currentUser() as ParseUser;
  debugPrint("Profile - $timeStoryUser");
  UserDataModel udm = uToPoConv.parseObjectToDomain(timeStoryUser); //Not getting user values here
  debugPrint("Profile - Username - ${udm.username}");
  return udm;
}

Future<List<TimeSheetDataModel>> getTimeSheetList() async {
  var tsRepo = TimeSheetRepository();
  List<TimeSheetDataModel> timeSheetList = await tsRepo.getAllWithProjectModel();
  return timeSheetList;
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

num getMins(num numberOfHrs) {
  int intHrs = numberOfHrs.toInt();
  num mins = numberOfHrs - intHrs;
  num minutes = intHrs * 60 + mins * 100;
  return minutes;
}

String getHrsMin(num min) {
  var hrs = (min ~/ 60).toString();
  String? minute = (min % 60).toInt().toString();
  return (hrs + ' hrs ' + minute + ' min');
}

String timeOfDayToString(TimeOfDay tod) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return DateFormat.jm().format(dt);
}

TimeOfDay stringToTimeOfDay(String ts) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(ts));
}

setNumberOfHrs(TimeOfDay startTime, TimeOfDay endTime) {
  int smin = startTime.hour * 60 + startTime.minute;
  int emin = endTime.hour * 60 + endTime.minute;
  double diffmin = (emin - smin) / 60;
  double _numberOfhrs = diffmin.toInt() + ((emin - smin) % 60) / 100;
  //debugPrint('Utilities:setNumberOfHrs numberofHrs: $_numberOfhrs');
  return _numberOfhrs;
}