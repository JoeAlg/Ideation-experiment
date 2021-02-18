import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/globals.dart';
import 'package:fu_ideation/utils/localization.dart';
import 'package:fu_ideation/utils/phaseManager.dart';
import 'package:fu_ideation/utils/ratingSystem.dart';
import 'IdeaListTile.dart';

class IdeasLiveList extends StatefulWidget {
  final int projectId;

  IdeasLiveList(this.projectId);

  @override
  _IdeasLiveListState createState() => _IdeasLiveListState();
}

class _IdeasLiveListState extends State<IdeasLiveList> {
  List ideasList = [];

  bool _shouldDisplay(String inviteCode) {
    if (inviteCode == null) return false;
    String currentUserInviteCode = sharedPreferencesGetValue('invitation_code');
    if (currentUserInviteCode == null) return false;
    if (getCurrentPhaseContentVisibilityValue() == 'hidden') {
      if (currentUserInviteCode != inviteCode) return false;
    }
    return true;
  }

  int _numUserUniqueRatings(ratingsMaps) {
    if (ratingsMaps == null || ratingsMaps.isEmpty) return 0;
    Map userUniqueRatings = {};
    for (final e in ratingsMaps) {
      userUniqueRatings[e['author_invitation_code']] = e;
    }
    return userUniqueRatings.keys.length;
  }

  double _averageRating(List ratingsMaps) {
    if (ratingsMaps == null || ratingsMaps.isEmpty) return 0;
    Map userUniqueRatings = {};
    List ratings = [];
    for (final e in ratingsMaps) {
      userUniqueRatings[e['author_invitation_code']] = e;
    }

    userUniqueRatings.forEach((k, v) {
      ratings.add(v['rating']);
    });

    if (ratings == null || ratings.isEmpty || ratings.contains(null)) return 0;
    double _sum = 1.0 * ratings.reduce((a, b) => a + b);
    double _avg = _sum / ratings.length;
    if (_avg > 5.0) return 5.0;
    return _sum / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance.collection('project_' + widget.projectId.toString());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          //visible: ideasList.isNotEmpty,
          visible: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(localStr('sort_by') + ': '),
              DropdownButton(
                  value: selectedDropDownValue,
                  items: [
                    DropdownMenuItem(value: 'created_on', child: Text(localStr('date'))),
                    DropdownMenuItem(value: 'number of ratings', child: Text(localStr('num_ratings'))),
                    DropdownMenuItem(value: 'number of comments', child: Text(localStr('num_comments'))),
                    DropdownMenuItem(value: 'average rating', child: Text(localStr('avg_rating'))),
                    DropdownMenuItem(value: 'author_name', child: Text(localStr('author'))),
                    DropdownMenuItem(value: 'title', child: Text(localStr('title'))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDropDownValue = value;
                    });
                  }),
            ],
          ),
        ),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Something went wrong');
              if (snapshot.connectionState == ConnectionState.none) return Text("please check your internet connection");
              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: Text("Loading...", style: TextStyle(color: Colors.grey),));

              //print(snapshot.data.docs.map.sort);

/*
              List ideasList = snapshot.data.docs.map((DocumentSnapshot document) {
                if (_shouldDisplay(document.data()['author_invitation_code'])) {
                  return new IdeaListTile(document.data());
                } else {
                  return Container();
                }
              }).toList();
*/

              ideasList = snapshot.data.docs.map((DocumentSnapshot document) {
                if (_shouldDisplay(document.data()['author_invitation_code'])) {
                  return document.data();
                }
              }).toList();

              if (ideasList.isEmpty){
                return Center(child: Text('\n\n\n' + localStr('no_ideas')));
              }

              if (selectedDropDownValue == 'created_on') {
                ideasList.sort((a, b) => b['created_on'].compareTo(a['created_on']));
              } else if (selectedDropDownValue == 'number of ratings') {
                ideasList.sort((a, b) => _numUserUniqueRatings(b['ratings']).toString().compareTo(_numUserUniqueRatings(a['ratings']).toString()));
              } else if (selectedDropDownValue == 'number of comments') {
                ideasList.sort((a, b) => b['comments'].length.compareTo(a['comments'].length));
              } else if (selectedDropDownValue == 'average rating') {
                ideasList.sort((a, b) => _averageRating(b['ratings']).compareTo(_averageRating(a['ratings'])));
              } else if (selectedDropDownValue == 'author') {
                ideasList.sort((a, b) => a['author_name'].compareTo(b['author_name']));
              } else if (selectedDropDownValue == 'title') {
                ideasList.sort((a, b) => a['title'].compareTo(b['title']));
              }

              List<Widget> ideaListTiles = [];

              for (int i = 0; i < ideasList.length; i++) {
                ideaListTiles.add(IdeaListTile(ideasList[i]));
              }

              if (ideaListTiles.length > 1 ) {
                ideaListTiles.insert(0, Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(localStr('sort_by') + ': '),
                    DropdownButton(
                        value: selectedDropDownValue,
                        items: [
                          DropdownMenuItem(value: 'created_on', child: Text(localStr('date'))),
                          DropdownMenuItem(value: 'number of ratings', child: Text(localStr('num_ratings'))),
                          DropdownMenuItem(value: 'number of comments', child: Text(localStr('num_comments'))),
                          DropdownMenuItem(value: 'average rating', child: Text(localStr('avg_rating'))),
                          DropdownMenuItem(value: 'author_name', child: Text(localStr('author'))),
                          DropdownMenuItem(value: 'title', child: Text(localStr('title'))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedDropDownValue = value;
                          });
                        }),
                  ],
                ));
              }

              Widget ideasListView = ListView(children: ideaListTiles);

              return ideasListView;
            },
          ),
        ),
      ],
    );
  }
}
