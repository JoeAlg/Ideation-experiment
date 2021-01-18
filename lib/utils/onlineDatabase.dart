import 'package:fu_ideation/APIs/firestore.dart';

Future<int> generateNewProjectIdOverFirestore() async {
  Map appConfigDoc = await firestoreGetDoc('_app_data', 'app_config');
  if (appConfigDoc == null) {
    print('ERROR: appConfigDoc == null');
    return null;
  }

  int projectId = appConfigDoc['project_id_counter'];
  if (projectId == null) {
    print('ERROR: projectId == null');
    return null;
  }

  bool _success = await firestoreWrite('_app_data', 'app_config', {'project_id_counter': projectId + 1});
  if (_success) {
    print('generateNewProjectIdOverFirestore(): _success == true');
    return projectId;
  } else {
    print('ERROR: firestoreWrite(.. project_id_counter) .. _success==null');
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
    print('sendInvitationCodesToFirestore() ERROR');
    return null;
  }
}


Future<int> getProjectIdByInvitationCode(String invitationCode) async {
  var projectId = await firestoreGetFieldValue('_app_data', 'invitation_codes', invitationCode);
  print('z1');
  if (projectId == null) return null;
  print('z2');
  if (projectId is int) {
    print('z3');
    return projectId;
  } else {
    print('z4');
    return null;
  }
}
