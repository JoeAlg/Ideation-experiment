import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';
import 'package:fu_ideation/utils/globals.dart';
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
      print('projectId is null');
      return;
    }

    projectInfo = await getProjectInfoById(projectId.toString());
    if (projectInfo == null) {
      print('projectInfo is null');
      return;
    }
    print('projectInfo1: ' + projectInfo.toString());

    userInfo = {
      'app_launches': null,
      'email': null,
      'invitation_code': null,
      'invitation_code_activated': null,
      'name': null,
      'status': null,
    };

    sharedPreferencesSetInt('project_id', projectId);
    sharedPreferencesSetString('invitation_code', _code);

    _invitationCodeTextFieldController.text = '';

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/participantInfoScreen',
      (r) => false,
      arguments: ParticipantInfoScreenArguments(
        'Welcome',
        'Welcome to the Experiment and thank you for the participation. You and other participants are expected to generate ideas for a name of a new bike repair shop, discuss and rate ideas from other participants and finally achieve a consensus on the best idea. Be creative and cooperative!',
      ),
    );
  }

  void navigateToLoginScreen() {
    Navigator.pushNamed(context, '/loginScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('invitation code'),
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
                      'are you an admin?',
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
                      'please enter your invitation code',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _invitationCodeTextFieldController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'invitation code...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      onPressed: _next,
                      child: Text('next'),
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
