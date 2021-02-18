import 'dart:developer';

import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';

import 'globals.dart';
import 'onlineDatabase.dart';

Future<bool> initUserInfo() async {
  try {
    String projectId = sharedPreferencesGetValue('project_id').toString();
    String inviteCode = sharedPreferencesGetValue('invitation_code');

    Map doc = await firestoreGetDoc('_projects_data', 'project_' + projectId);
    if (doc == null) return false;
    userInfo = doc['participants'][inviteCode];
  } catch (e) {
    print ('initUserInfo ERROR: ' + e.toString());
    return false;
  }
  return true;
}

Future<bool> initProjectInfo() async {
  try {
    int projectId = sharedPreferencesGetValue('project_id');
    if (projectId == null) {
      return null;
    }
    projectInfo = await getProjectInfoById(projectId.toString());
    if (projectInfo == null) {
      return false;
    }
  } catch (e) {
    return false;
  }
  return true;
}