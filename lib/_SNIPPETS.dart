///for loop:
/*
for( var i = 0 ; i < 10; i++ ) {
  //code...
}
*/

///iterate map:
/*
documentData.forEach((k, v) {
  //do something with k and v;
});
*/

///iterate list:
/*
for(final e in li){
  var currentElement = e;
}
*/

///map to list:
/*
List documentList = documentMap.entries.map((entry) => entry.value).toList();
*/


///loading indicator with timer:
/*


child: loadingTimerFinished
  ? Text(
      buttonText,
      textAlign: TextAlign.center,
      softWrap: true,
      style: TextStyle(fontSize: 40, color: textColor, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    )
  : CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
    ),
*/


///wait for 5 seconds:
//await Future.delayed(Duration(seconds: 1));


/// get live firestore document
/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';

class ProjectsCardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get the course document using a stream
    Stream<DocumentSnapshot> docStream = FirebaseFirestore.instance.collection('_projects_data').doc('projects').snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: docStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var documentMap = snapshot.data.data();
            //List documentList = documentMap.keys;
            if (documentMap == null){
              return Center(child: Text('there are no projects registered'),);
            }
            List documentList = documentMap.entries.map((entry) => entry.value).toList();

            return ListView.builder(
                itemCount: documentList != null ? documentList.length : 0,
                itemBuilder: (_, int index) {
                  return ListTile(title: FlatButton(child: Text(documentList[index]['title']), color: Colors.white,                 onPressed: (){
                    Navigator.pushNamed(
                      context,
                      '/adminProjectOverviewScreen',
                      arguments: ProjectOverviewScreenArguments(documentList[index]['title']),
                    );
                  },));
                });
          } else {
            return Container();
          }
        });
  }
}


*/


/// get live firestore collection:
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/utils/dateTimeFormatter.dart';
import 'package:fu_ideation/utils/ratingSystem.dart';
import '../utils/ScreenArguments.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class IdeasLiveList extends StatelessWidget {
  final int projectId;

  IdeasLiveList(this.projectId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('project_' + projectId.toString());

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
                          Text(document.data()['title'], style: TextStyle(fontSize: 18),),
                          FutureBuilder<double>(
                            future: getAverageRating(projectId, ideaId), // async work
                            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Text('Loading....');
                                default:
                                  if (snapshot.hasError)
                                    return Text('Error: ${snapshot.error}');
                                  else
                                    return RatingBarIndicator(
                                      rating: snapshot.data,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 25.0,
                                      direction: Axis.horizontal,
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('' + dateTimeToString(document.data()['created_on'].toDate()), style: TextStyle(fontSize: 10, color: Colors.grey),),
                          Text(''),
                        ],
                      ),
                    ],
                  ),
                ),
                onPressed: (){
                  Navigator.pushNamed(
                    context,
                    '/ideaOverviewScreen',
                    arguments: IdeaOverviewScreenArguments(document.data()['title'], document.id),
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

*/


///FutureBuilder:
/*
FutureBuilder<double>(
  future: getAverageRating(sharedPreferencesGetValue('project_id'), args.ideaId), // async work
  builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return Text('Loading....');
      default:
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        else
          return snapshot.data == null
              ? RatingBarIndicator(
                  rating: 0,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 25.0,
                  direction: Axis.horizontal,
                )
              : RatingBarIndicator(
                  rating: snapshot.data,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 25.0,
                  direction: Axis.horizontal,
                );
    }
  },
)

*/
