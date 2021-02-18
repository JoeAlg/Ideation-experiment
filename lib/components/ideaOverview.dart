import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'commentsSection.dart';

class IdeaOverview extends StatelessWidget {
  final int projectId;
  final int ideaId;

  IdeaOverview(this.projectId, this.ideaId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('project_' + projectId.toString()).doc('idea_' + ideaId.toString()).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> document) {
          if (document.connectionState == ConnectionState.active) {
            var documentMap = document.data.data();
            if (documentMap == null) {
              return Center(
                child: Text('error loading data'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              documentMap['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        FlatButton(
                            //TODO onPressed: () => rateIdea(args.ideaId),
                            onPressed: () {},
                            child: RatingBarIndicator(
                              rating: 0,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 25.0,
                              direction: Axis.horizontal,
                            )),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'anonymous, ' + '20.12.2020 13:53',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommentSection(),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            //TODO controller: newCommentController,
                            //keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'add comment...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: FlatButton(
                          child: Icon(Icons.send, size: 40, color: Colors.blue),
                          //TODO onPressed: () => sendComment(args.ideaId),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
