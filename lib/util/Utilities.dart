import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timestory_back4app/views/NavigateMenusTopBar.dart';
import '../main.dart';

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