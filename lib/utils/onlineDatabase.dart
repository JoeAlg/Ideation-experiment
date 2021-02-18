import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';

import 'globals.dart';

Future<int> generateNewProjectIdOverFirestore() async {
  Map appConfigDoc = await firestoreGetDoc('_app_data', 'app_config');
  if (appConfigDoc == null) {
    print ('ERROR: appConfigDoc == null');
    return null;
  }

  int projectId = appConfigDoc['project_id_counter'];
  if (projectId == null) {
    print ('ERROR: projectId == null');
    return null;
  }

  bool _success = await firestoreWrite('_app_data', 'app_config', {'project_id_counter': projectId + 1});
  if (_success) {
    print ('generateNewProjectIdOverFirestore(): _success == true');
    return projectId;
  } else {
    print ('ERROR: firestoreWrite(.. project_id_counter) .. _success==null');
    return null;
  }
}

Future<Map> generateNewInvitationCodesOverFirestore(int projectId, int numInvitationCodes) async {
  Map appConfigDoc = await firestoreGetDoc('_app_data', 'app_config');
  if (appConfigDoc == null) {
    return null;
  }

  int invitationCodeCounter = appConfigDoc['invitation_code_counter'];
  if (invitationCodeCounter == null) {
    return null;
  }

  Map<String, dynamic> invitationCodesMap = {};
  for (var i = 0; i < numInvitationCodes; i++) {
    String _invitationCode = i.toString().padLeft(6, '0');
    invitationCodesMap[_invitationCode] = projectId;
    invitationCodeCounter += 1;
  }

  bool _success = await firestoreWrite('_app_data', 'invitation_codes', invitationCodesMap);
  if (_success) {
    return invitationCodesMap;
  } else {
    print ('sendInvitationCodesToFirestore() ERROR');
    return null;
  }
}


Future<int> getProjectIdByInvitationCode(String invitationCode) async {
  var projectId = await firestoreGetFieldValue('_app_data', 'invitation_codes', invitationCode);
  if (projectId == null) return null;
  if (projectId is int) {
    return projectId;
  } else {
    return null;
  }
}

Future<Map> getProjectInfoById(String projectId) async {
  try {
    Map projectDoc = await firestoreGetDoc('_projects_data', 'project_' + projectId);
    return projectDoc;
  } catch(e){
    return null;
  }
}

Future<bool> logAppLaunch() async {
  try {
    String invitationCode = sharedPreferencesGetValue('invitation_code');
    int projectId = sharedPreferencesGetValue('project_id');
    List appLaunchesList = projectInfo['participants'][invitationCode]['app_launches'];
    appLaunchesList.add(DateTime.now());
    var data = {'participants' : {sharedPreferencesGetValue('invitation_code') : {'app_launches' : appLaunchesList}}};
    firestoreWrite('_projects_data', 'project_' + projectId.toString(), data);
    return true;
  } catch(e){
    return false;
  }
}
