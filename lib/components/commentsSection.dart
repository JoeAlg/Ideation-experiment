import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

ScrollController commentListViewController = new ScrollController();
class CommentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get the course document using a stream
    Stream<DocumentSnapshot> docStream = FirebaseFirestore.instance.collection('project2').doc('2020-12-09 12:05:02.496808').snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: docStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var documentMap = snapshot.data.data();
            //List documentList = documentMap.keys;
            if (documentMap == null){
              return Center(child: Text('no comments'),);
            }

            return ListView.builder(
              controller: commentListViewController,
                itemCount: documentMap['comments'].length,
                itemBuilder: (_, int index) {
                  return ListTile(title: Text('anonymous:  ' + documentMap['comments'][index]));
                });
          } else {
            return Container();
          }
        });
  }
}
