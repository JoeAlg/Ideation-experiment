import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/components/ideasCardsList.dart';
import 'package:fu_ideation/utils/globals.dart';
import 'package:fu_ideation/utils/localization.dart';
import 'package:fu_ideation/utils/phaseManager.dart';

class ParticipantProjectScreen extends StatefulWidget {
  ParticipantProjectScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ParticipantProjectScreenState createState() => _ParticipantProjectScreenState();
}

class _ParticipantProjectScreenState extends State<ParticipantProjectScreen> {
  void navigateToCreateNewIdeaScreen() {
    Navigator.pushNamed(context, '/createIdeaScreen');
  }

  void logOut() {
    sharedPreferencesSetString('invitation_code', null);
    Navigator.pushNamedAndRemoveUntil(context, "/invitationCodeScreen", (r) => false);
  }

  bool currentPhaseInfoSeen() {
    int currentPhaseId = getCurrentPhaseId();
    if (currentPhaseId == null) return true;
    bool currentPhaseInfoSeen = sharedPreferencesGetValue('phase_' + currentPhaseId.toString() + '_info_seen');
    return currentPhaseInfoSeen ?? false;
  }

  void displayInfoPopUp() {
    sharedPreferencesSetBool('phase_' + getCurrentPhaseId().toString() + '_info_seen', true);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //Text('######\n' + userInfo.toString() + '\n######', style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                        SizedBox(height: 20),
                        Text('phase ' + getCurrentPhaseId().toString(), style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                        SizedBox(height: 20),
                        Text(getCurrentPhaseDescription().toString(), style: TextStyle(fontSize: 20), textAlign: TextAlign.justify),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ok',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (!currentPhaseInfoSeen()) {
        displayInfoPopUp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(localStr('ideas')),
            FlatButton(
                onPressed: () {},
                onLongPress: logOut,
                child: Icon(
                  Icons.logout,
                  color: Colors.transparent,
                )),
            getCurrentPhaseId() != null
                ? IconButton(
                    onPressed: displayInfoPopUp,
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ))
                : Container(),
          ],
        ),
      ),
      body: IdeasLiveList(sharedPreferencesGetValue('project_id')),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateNewIdeaScreen,
        tooltip: 'add new idea',
        child: Icon(Icons.add),
      ),
    );
  }
}
