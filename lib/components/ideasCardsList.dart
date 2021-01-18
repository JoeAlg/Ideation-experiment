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
              title: Card(
                child: FlatButton(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Text(
                                document.data()['title'],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            document.data()['ratings'] == null || document.data()['ratings'].isEmpty
                                ? Text(
                                    'not rated',
                                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                  )
                                : RatingBarIndicator(
                                    rating: getAverageRating2(document.data()['ratings']),
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18.0,
                                    direction: Axis.horizontal,
                                  ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Text('' + dateTimeToString(document.data()['created_on'].toDate), style: TextStyle(fontSize: 10, color: Colors.grey),),
                            Text(
                              'by ' + document.data()['author_name'] + ', ' + dateTimeToString(document.data()['created_on'].toDate()),
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/ideaOverviewScreen',
                      arguments: IdeaOverviewScreenArguments(document.data()['id']),
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
