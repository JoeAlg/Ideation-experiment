import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/APIs/localNotifications.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';
import 'package:fu_ideation/utils/globals.dart';
import 'package:fu_ideation/utils/globalsManager.dart';
import 'package:fu_ideation/utils/localization.dart';
import 'package:fu_ideation/utils/onlineDatabase.dart';

class InvitationCodeScreen extends StatefulWidget {
  InvitationCodeScreen({Key key}) : super(key: key);

  @override
  _InvitationCodeScreenState createState() => _InvitationCodeScreenState();
}

class _InvitationCodeScreenState extends State<InvitationCodeScreen> {
  TextEditingController _invitationCodeTextFieldController = new TextEditingController();

  Future<void> _next() async {
    String _code = _invitationCodeTextFieldController.text;
    if (_code == null || _code == '') return;
    //check validity over Firebase:
    int projectId = await getProjectIdByInvitationCode(_code);
    if (projectId == null) {
      print ('projectId is null');
      return;
    }

    projectInfo = await getProjectInfoById(projectId.toString());
    if (projectInfo == null) {
      print ('projectInfo is null');
      return;
    }


    var data = {'participants' : {_code : {'invitation_code_activated': DateTime.now()}}};

    firestoreWrite('_projects_data', 'project_' + projectId.toString(), data);
    sharedPreferencesSetInt('project_id', projectId);
    sharedPreferencesSetString('invitation_code', _code);

    await initUserInfo();

    List phases = projectInfo['phases'];
    if (phases.length > 0){
      phases.removeAt(0);
    }
    for (var e in phases){
      scheduleNotification(localStr('new_phase_notif_title'), localStr('new_phase_notif_title'), e['start_date_time'].toDate(), e['phase_id']);
    }

    _invitationCodeTextFieldController.text = '';

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/participantInfoScreen',
      (r) => false,
      arguments: ParticipantInfoScreenArguments(localStr('welcome'), projectInfo['description'].toString()),
    );
  }

  void navigateToLoginScreen() {
    Navigator.pushNamed(context, '/loginScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localStr('invite_code')),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text(
                      localStr('admin_login_btn'),
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                    color: Colors.transparent,
                    onPressed: navigateToLoginScreen,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 150,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      localStr('enter_invite_code'),
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _invitationCodeTextFieldController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: localStr('invite_code'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      onPressed: _next,
                      child: Text(localStr('next')),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
