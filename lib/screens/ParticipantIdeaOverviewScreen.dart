import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fu_ideation/utils/commentsFormatter.dart';
import 'package:fu_ideation/utils/ratingSystem.dart';

class IdeaOverviewScreen extends StatefulWidget {
  IdeaOverviewScreen({Key key}) : super(key: key);

  @override
  _IdeaOverviewScreenState createState() => _IdeaOverviewScreenState();
}

class _IdeaOverviewScreenState extends State<IdeaOverviewScreen> {
  TextEditingController newCommentController = new TextEditingController();
  ScrollController _commentsScrollController = new ScrollController();
  double submittedRating;
  String ideaTitle;

  void navigateToParticipantProjectScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/participantProjectScreen',
      (r) => false,
    );
  }

  Future<void> saveRating(int ideaId) async {
    int projectId = sharedPreferencesGetValue('project_id');
    List ratings = await firestoreGetFieldValue('project_' + projectId.toString(), 'idea_' + ideaId.toString(), 'ratings');
    if (ratings == null) {
      //TODO display error
      return;
    }

    bool currentUserAlreadyRatedCurrentIdea;
    for (final e in ratings) {
      var currentElement = e;
    }

    //List ratings = [];
    String currentUserInvitationCode = sharedPreferencesGetValue('invitation_code');
    Map ratingMap = {
      'author_invitation_code': currentUserInvitationCode,
      'author_name': currentUserInvitationCode,
      'rating': submittedRating,
      'rated_at': DateTime.now(),
    };
    //ratings.add(submittedRating);
    //firestoreWrite('project_' + projectId.toString(), 'idea_' + ideaId.toString(), {'ratings' : [ratingMap]});
    print('ÄÄÄÄ:  ' + 'project_' + projectId.toString() + '   idea_' + ideaId.toString());
    firestoreAddToArray('project_' + projectId.toString(), 'idea_' + ideaId.toString(), 'ratings', [ratingMap]);
    Navigator.pop(context);
    setState(() {});
  }

  Future<void> sendComment(int projectId, int ideaId) async {
    //FocusScope.of(context).unfocus();

    String currentUserInvitationCode = sharedPreferencesGetValue('invitation_code');

    var commentMap = {
      'author_invitation_code': currentUserInvitationCode, //invitation_code
      'author_name': currentUserInvitationCode, //invitation_code
      'comment': newCommentController.text,
      'commented_at': DateTime.now(),
    };

    firestoreAddToArray('project_' + projectId.toString(), 'idea_' + ideaId.toString(), 'comments', [commentMap]);
    //newCommentController.text = '';
    newCommentController.clear();
    setState(() {});
  }

  void rateIdea(int ideaId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              //height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'rate this idea',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      wrapAlignment: WrapAlignment.center,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        submittedRating = rating;
                        print(rating);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () => saveRating(ideaId),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "rate",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final IdeaOverviewScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //Text('idea overview'),
            FlatButton(
                onPressed: () => rateIdea(args.ideaId),
                child: Text(
                  'rate',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('project_' + sharedPreferencesGetValue('project_id').toString())
              .doc('idea_' + args.ideaId.toString())
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> document) {
            if (document.connectionState == ConnectionState.active) {
              var documentMap = document.data.data();
              if (documentMap == null) {
                return Center(
                  child: Text('error loading data'),
                );
              }
              List documentList = documentMap.entries.map((entry) => entry.value).toList();

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
                          documentMap['ratings'].isEmpty
                              ? Text('not rated')
                              : FlatButton(
                                  onPressed: () => rateIdea(args.ideaId),
                                  child: RatingBarIndicator(
                                    rating: getAverageRating2(documentMap['ratings']),
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18.0,
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
                        /*
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(children: [
                            Icon(Icons.insert_comment_outlined),
                            Text('14 ')
                          ]),
                        ),
                        */
                        Container(
                          child: Text(
                            documentMap['author_name'] + ', ' + '20.12.2020 13:53',
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        //child: CommentSection(),
                        //child: ListView(children: commentsSection(documentMap['comments'])),
                        child: ListView(
                          controller: _commentsScrollController,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: commentsSection(documentMap['comments']),
                              ),
                            ),
                          ],
                        ),
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
                              controller: newCommentController,
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
                            onPressed: () => sendComment(sharedPreferencesGetValue('project_id'), args.ideaId),
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
          }),
    );
  }
}
