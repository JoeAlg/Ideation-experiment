import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';
import 'package:fu_ideation/utils/globals.dart';

class ProjectsCardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('_projects_data');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: Card(
                child: new FlatButton(
                  //color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(document.data()['title']),
                      new Text(document.data()['status']),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/adminProjectOverviewScreen',
                      arguments: ProjectOverviewScreenArguments(document.data()['project_id']),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
