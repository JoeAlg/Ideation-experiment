import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';

List<InlineSpan> commentsSection(List comments) {
  List<InlineSpan> textSpans = [];
  String currentUserInvitationCode = sharedPreferencesGetValue('invitation_code');
  for (var e in comments) {
    if (e['author_invitation_code'] == null || e['author_name'] == null || e['comment'] == null) continue;
    String authorText = currentUserInvitationCode == e['author_invitation_code'] ? 'me' : e['author_name'];
    textSpans.add(TextSpan(text: '\n' + authorText + ': ', style: TextStyle(fontWeight: FontWeight.bold)));
    textSpans.add(TextSpan(text: e['comment']));
  }
  return textSpans;
}
