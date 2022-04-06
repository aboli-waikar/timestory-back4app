import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:timestory_back4app/repositories/UserRepository.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = "NlPHrKFNMM8jUIM3A48yxGB3pQghhPOOrwC7xVSZ";
  const keuClientKey = "oRF71shyaQ7sqLP1ZrRti3gK2CbjGvO6xy8ckJL3";
  const parseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, parseServerUrl, clientKey: keuClientKey, autoSendSessionId: true);

  group('User Repository Tests', ()
  {
    test('Get All Users', () {
      var userRepo = UserRepository();
      var allUsers = userRepo.getAll();
      expect(allUsers != null, true);
    });
  });
}