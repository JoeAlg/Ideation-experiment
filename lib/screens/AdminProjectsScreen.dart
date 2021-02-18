import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/firebaseAuth.dart';
import 'package:fu_ideation/components/projectsCardsList.dart';
import 'package:fu_ideation/utils/globals.dart';

class AdminProjectsScreen extends StatefulWidget {
  AdminProjectsScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AdminProjectsScreenState createState() => _AdminProjectsScreenState();
}

class _AdminProjectsScreenState extends State<AdminProjectsScreen> {
  void navigateToCreateProjectScreen() {
    lastPhaseId = 0;
    Navigator.pushNamed(context, '/createProjectScreen');
  }

  void adminSignOut() {
    Navigator.pushNamedAndRemoveUntil(context, "/invitationCodeScreen", (r) => false);
    signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('projects'),
            FlatButton(child: Icon(Icons.logout, color: Colors.white,), onPressed: adminSignOut,)
          ],
        ),
      ),
      body: SafeArea(
        child:
        ProjectsCardsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateProjectScreen,
        tooltip: 'add new idea',
        child: Icon(Icons.add),
      ),
    );
  }
}
