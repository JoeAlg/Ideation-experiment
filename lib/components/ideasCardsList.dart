import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/localization.dart';
import 'package:fu_ideation/utils/phaseManager.dart';
import 'IdeaListTile.dart';

class IdeasLiveList extends StatefulWidget {
  final int projectId;

  IdeasLiveList(this.projectId);

  @override
  _IdeasLiveListState createState() => _IdeasLiveListState();
}

class _IdeasLiveListState extends State<IdeasLiveList> {
  String selectedDropDownValue = 'created_on';

  bool _shouldDisplay(String inviteCode) {
    if (inviteCode == null) return false;
    String currentUserInviteCode = sharedPreferencesGetValue('invitation_code');
    if (currentUserInviteCode == null) return false;
    if (getCurrentPhaseContentVisibilityValue() == 'hidden') {
      if (currentUserInviteCode != inviteCode) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Query users = FirebaseFirestore.instance
        .collection('project_' + widget.projectId.toString())
        .orderBy(selectedDropDownValue ?? 'created_on', descending: selectedDropDownValue == 'created_on');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localStr('sort_by') + ': '),
            DropdownButton(
                value: selectedDropDownValue,
                items: [
                  DropdownMenuItem(value: 'created_on', child: Text(localStr('date'))),
                  //DropdownMenuItem(value: 'number of ratings', child: Text('number of ratings')),
                  //DropdownMenuItem(value: 'number of comments', child: Text('number of comments')),
                  //DropdownMenuItem(value: 'average rating', child: Text('average rating')),
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
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Something went wrong');
              if (snapshot.connectionState == ConnectionState.none) return Text("please check your internet connection");
              if (snapshot.connectionState == ConnectionState.waiting) return Text("Loading...");

              //print(snapshot.data.docs.map.sort);

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  if (_shouldDisplay(document.data()['author_invitation_code'])) {
                    return new IdeaListTile(document.data());
                  } else {
                    return Container();
                  }
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
