import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/components/ideasCardsList.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ideas'),
            FlatButton(onPressed: logOut, child: Icon(Icons.logout, color: Colors.white,))
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
