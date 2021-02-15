import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'IdeaListTile.dart';

class IdeasLiveList extends StatelessWidget {
  final int projectId;

  IdeasLiveList(this.projectId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('project_' + projectId.toString());

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.none) return Text("please check your internet connection");
        if (snapshot.connectionState == ConnectionState.waiting) return Text("Loading...");
        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new IdeaListTile(document.data());
          }).toList(),
        );
      },
    );
  }
}
