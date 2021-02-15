import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectsLiveDetails extends StatelessWidget {
  final int projectId;

  ProjectsLiveDetails(this.projectId);

  @override
  Widget build(BuildContext context) {
    // get the course document using a stream


    Stream<DocumentSnapshot> docStream = FirebaseFirestore.instance.collection('_projects_data').doc('project_' + projectId.toString()).snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: docStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var documentMap = snapshot.data.data();
            //List documentList = documentMap.keys;
            if (documentMap == null) {
              return Center(
                child: Text('error loading data'),
              );
            }

            return Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    Text(documentMap['title']),
                    Text('000000'),
                    Text('000001'),
                    Text('000002'),
                    Text('000003'),
                    Text('000004'),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
