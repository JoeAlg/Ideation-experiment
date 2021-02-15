import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/components/ideasCardsList.dart';
import 'package:fu_ideation/utils/globals.dart';
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

  void displayInfoPopUp() {
    log('projectInfo: ' + projectInfo.toString());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        SizedBox(height: 20),
                        Text('phase ' + getCurrentPhaseId().toString(), style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                        SizedBox(height: 20),
                        Text('Ö: ' + getCurrentPhaseDescription(), style: TextStyle(fontSize: 20), textAlign: TextAlign.justify),
                        SizedBox(height: 20),
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
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ideas'),
            FlatButton(
                onPressed: logOut,
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
            getCurrentPhaseId() != null ? IconButton(
                onPressed: displayInfoPopUp,
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                )) : Container(),
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
