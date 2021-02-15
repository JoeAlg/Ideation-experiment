import 'dart:developer';

import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';

import 'globals.dart';
import 'onlineDatabase.dart';

Future<bool> initUserInfo() async {
  try {
    Map doc = await firestoreGetDoc('collectionName', 'documentName');
    if (doc == null) return false;
    userInfo = {
      'app_launches': null,
      'email': null,
      'invitation_code': null,
      'invitation_code_activated': null,
      'name': null,
      'status': null,
    };
  } catch (e) {
    return false;
  }
  return true;
}

Future<bool> initProjectInfo() async {
  print('701');
  try {
    int projectId = sharedPreferencesGetValue('project_id');
    if (projectId == null) {
      print('70');
      return null;
    }
    print('703');
    print('8881: ');
    projectInfo = await getProjectInfoById(projectId.toString());
    log('8882: ' + projectInfo.toString());
    if (projectInfo == null) {
      return false;
    }
  } catch (e) {
    return false;
  }
  return true;
}