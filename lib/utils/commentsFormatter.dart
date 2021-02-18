import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/utils/phaseManager.dart';

import 'localization.dart';

List<InlineSpan> commentsSection(List comments) {
  List<InlineSpan> textSpans = [];
  String currentUserInvitationCode = sharedPreferencesGetValue('invitation_code');
  String contentVisibility = getCurrentPhaseContentVisibilityValue();
  for (var e in comments) {
    if (e['author_invitation_code'] == null || e['author_name'] == null || e['comment'] == null) continue;
    String authorText;
    if (currentUserInvitationCode == e['author_invitation_code']){
      authorText =  localStr('me');
    } else if (contentVisibility == 'visible'){
      authorText = e['author_name'];
    } else if (contentVisibility == 'pseudonymized'){
      authorText = e['author_pseudonym'];
    } else if (contentVisibility == 'anonymized'){
      authorText = 'anonymous';
    } else {
      authorText = localStr('user');
    }
    textSpans.add(TextSpan(text: '\n' + authorText + ': ', style: TextStyle(fontWeight: FontWeight.bold)));
    textSpans.add(TextSpan(text: e['comment']));
  }
  return textSpans;
}
