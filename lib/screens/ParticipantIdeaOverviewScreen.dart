import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fu_ideation/utils/commentsFormatter.dart';
import 'package:fu_ideation/utils/dateTimeFormatter.dart';
import 'package:fu_ideation/utils/globals.dart';
import 'package:fu_ideation/utils/localization.dart';
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
  Map documentMap;

  void navigateToParticipantProjectScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/participantProjectScreen',
      (r) => false,
    );
  }

  String authorAndDateStr(){
    String author = documentMap['author_name'];
    String ideaDate = dateTimeToAgoString(documentMap['created_on'].toDate());
    if (author == null){
      return ideaDate;
    } else {
      return author + '\n' + ideaDate;
    }
  }

  void _deleteIdea(val) {
    int projectId = sharedPreferencesGetValue('project_id');
    firestoreDeleteDocument('project_' + projectId.toString(), 'idea_' + selectedIdeaId.toString());
    navigateToParticipantProjectScreen();
  }

  Future<void> saveRating(int ideaId) async {
    if (submittedRating == null) return;
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
    firestoreAddToArray('project_' + projectId.toString(), 'idea_' + ideaId.toString(), 'ratings', [ratingMap]);
    Navigator.pop(context);
    setState(() {});
  }

  Future<void> sendComment(int projectId, int ideaId) async {

    String currentUserInvitationCode = sharedPreferencesGetValue('invitation_code');

    var commentMap = {
      'author_invitation_code': currentUserInvitationCode, //invitation_code
      'author_name': userInfo['name'] ?? '?', //invitation_code
      'author_pseudonym': userInfo['pseudonym'] ?? '?', //invitation_code
      'comment': newCommentController.text,
      'commented_at': DateTime.now(),
    };

    firestoreAddToArray('project_' + projectId.toString(), 'idea_' + ideaId.toString(), 'comments', [commentMap]);
    newCommentController.clear();
    _commentsScrollController.animateTo(
      _commentsScrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );

    setState(() {});
  }

  bool isCurrentUsersIdea(){
    if (documentMap == null) return false;
    String ideaAuthor = documentMap['author_invitation_code'];
    if (ideaAuthor == null) return false;
    String currentUserInviteCode = sharedPreferencesGetValue('invitation_code');
    if (currentUserInviteCode == null) return false;
    if (ideaAuthor.toString() == currentUserInviteCode.toString()){
      return true;
    } else {
      return false;
    }
  }

  double currentUserRating(){
    double currentUserRating;
    List ratingsList = documentMap['ratings'];
    //String currentUserInvitationCode = userInfo['invitation_code'];
    String currentUserInvitationCode = sharedPreferencesGetValue('invitation_code');
    for (Map e in ratingsList) {
      if (e['author_invitation_code'] == currentUserInvitationCode) {
        currentUserRating = e['rating'] * 1.0;
      }
    }
    return currentUserRating;
  }

  void rateIdea() {
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
                    localStr('rate_this_idea'),
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RatingBar.builder(
                      initialRating: currentUserRating() ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      wrapAlignment: WrapAlignment.center,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        submittedRating = rating;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () => saveRating(documentMap['id']),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        localStr('rate'),
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
            FlatButton(
                onPressed: () => rateIdea(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white),
                    Text(
                      localStr('rate'),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                )),
            Visibility(
              visible: isCurrentUsersIdea(),
              child: PopupMenuButton(
                onSelected: _deleteIdea,
                itemBuilder: (context) {
                  var list = List<PopupMenuEntry<Object>>();
                  list.add(
                    PopupMenuItem(
                      child: Text(
                        'delete idea',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: 2,
                    ),
                  );
                  return list;
                },
              ),
            ),
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
              documentMap = document.data.data();
              if (documentMap == null) {
                return Center(
                  child: Text('error loading data'),
                );
              }

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    color: Color(0xFFEEEEEE),
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 18.0, bottom: 0),
                                  child: Text(
                                    documentMap['title'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 18.0, bottom: 0),
                                    child: Text(
                                      documentMap['description'],
                                      //'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tristique congue neque sed fringilla. Fusce nec finibus magna. Morbi in auctor justo, aliquet varius arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed lacus velit, dictum nec blandit non, vestibulum nec nunc. Aliquam nec. ',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                //color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        authorAndDateStr(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          documentMap['ratings'].isEmpty
                                              ? FlatButton(
                                            child: Text(localStr('not_rated'), style: TextStyle(color: Colors.grey),),
                                            onPressed: () => rateIdea(),
                                          )
                                              : Column(
                                            children: [
                                              FlatButton(
                                                padding: const EdgeInsets.all(0.0),
                                                onPressed: () => rateIdea(),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.person, size: 13, color: Colors.grey),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          documentMap['ratings'].length.toString(),
                                                          style: TextStyle(color: Colors.grey, fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                    RatingBarIndicator(
                                                      rating: getAverageRating2(documentMap['ratings']),
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
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: !documentMap['ratings'].isEmpty,
                                            child: Row(
                                              children: [
                                                Text(localStr('your_rating') + ': ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                Text(currentUserRating().toString() ?? '?', style: TextStyle(color: Colors.grey)),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
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
                        SizedBox(height: 70),
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xFFFAFAFA),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: newCommentController,

                              //keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: localStr('add_comment') + '...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  )),
                            ),
                          ),
                        ),
                        FlatButton(
                          child: Icon(Icons.send, size: 32, color: Colors.blue),
                          onPressed: () => sendComment(sharedPreferencesGetValue('project_id'), args.ideaId),
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
