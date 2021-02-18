import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/dateTimeFormatter.dart';
import 'package:fu_ideation/utils/globals.dart';
import 'package:fu_ideation/utils/localization.dart';
import 'package:fu_ideation/utils/phaseManager.dart';
import 'package:fu_ideation/utils/ratingSystem.dart';
import '../utils/ScreenArguments.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class IdeaListTile extends StatefulWidget {
  final Map ideaMap;

  IdeaListTile(this.ideaMap);

  @override
  _IdeaListTileState createState() => _IdeaListTileState();
}

class _IdeaListTileState extends State<IdeaListTile> {

  String authorNameAndDate() {
    String dateTimeStr = dateTimeToAgoString(widget.ideaMap['created_on'].toDate());
    String currentUserInvitationCode = sharedPreferencesGetValue('invitation_code').toString();
    if (currentUserInvitationCode == widget.ideaMap['author_invitation_code']) {
      return localStr('me') + ', ' + dateTimeStr;
    }
    String contentVisibility = getCurrentPhaseContentVisibilityValue();
    if (contentVisibility == null) {
      return '?';
    }

    if (contentVisibility == 'visible') {
      String authorName =  widget.ideaMap['author_name'];
      if (authorName == null) return dateTimeStr;
      return authorName + ', ' + dateTimeStr;
    } else if (contentVisibility == 'pseudonymized') {
      String authorPseudonym =  widget.ideaMap['author_pseudonym'];
      if (authorPseudonym == null) return dateTimeStr;
      return localStr('user') + '-' + widget.ideaMap['author_pseudonym'] + ', ' + dateTimeStr;
    } else if (contentVisibility == 'anonymized') {
      return 'anonymous' + ', ' + dateTimeStr;
    } else {
      return dateTimeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      selectedTileColor: Colors.green,
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
                    Expanded(
                      child: Text(
                        widget.ideaMap['title'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    widget.ideaMap['ratings'] == null || widget.ideaMap['ratings'].isEmpty
                        ? Text(
                            localStr('not_rated'),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          )
                        : RatingBarIndicator(
                            rating: getAverageRating2(widget.ideaMap['ratings']),
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
                    Flexible(
                      child: Text(
                        authorNameAndDate(),
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*
                        Icon(Icons.star, size: 13, color: Colors.grey),
                        SizedBox(width: 2),
                        Text('5', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        SizedBox(width: 6),
                        */
                        Icon(Icons.comment, size: 13, color: Colors.grey),
                        SizedBox(width: 2),
                        Text(widget.ideaMap['comments'].length.toString(), style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          onPressed: () {
            selectedIdeaId = widget.ideaMap['id'].toString();
            Navigator.pushNamed(
              context,
              '/ideaOverviewScreen',
              arguments: IdeaOverviewScreenArguments(widget.ideaMap['id'], widget.ideaMap['author_invitation_code']),
            );
          },
        ),
      ),
    );
  }
}
