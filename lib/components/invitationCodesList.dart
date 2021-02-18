import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/utils/globals.dart';
import '../utils/ScreenArguments.dart';

class IdeasLiveList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('project2');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.none) {
          return Text("please check your internet connection");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: FlatButton(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ö ' + document.data()['title'], style: TextStyle(fontSize: 18),),
                          Text('*'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ö ' + document.data()['title']),
                          Text('*'),
                        ],
                      ),
                    ],
                  ),
                ),
                onPressed: (){
                  selectedIdeaId = document.data()['id'];
                  Navigator.pushNamed(
                    context,
                    '/ideaOverviewScreen',
                    arguments: IdeaOverviewScreenArguments(document.data()['id'], document.data()['author_invitation_code']),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
