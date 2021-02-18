import 'package:fu_ideation/APIs/sharedPreferences.dart';

import 'globals.dart';

var localized = {
  'next': {
    'en': 'next',
    'de': 'weiter',
  },
  'enter_invite_code': {
    'en': 'please enter your invitation code',
    'de': 'Bitte geben Sie Ihren Einladungscode ein',
  },
  'invite_code': {
    'en': 'invitation code',
    'de': 'Einladungscode',
  },
  'admin_login_btn': {
    'en': 'Are you an admin?',
    'de': 'Sind Sie ein Administrator?',
  },
  'welcome': {
    'en': 'Welcome',
    'de': 'Willkommen',
  },
  'go_to_experiment': {
    'en': 'go to experiment',
    'de': 'weiter zum Experiment',
  },
  'idea': {
    'en': 'idea',
    'de': 'Idee',
  },
  'ideas': {
    'en': 'ideas',
    'de': 'Ideen',
  },
  'add_comment': {
    'en': 'add comment',
    'de': 'mein Kommentar',
  },
  'me': {
    'en': 'me',
    'de': 'ich',
  },
  'rate': {
    'en': 'rate',
    'de': 'bewerten',
  },
  'not_rated': {
    'en': 'not rated',
    'de': 'keine Bewertungen',
  },
  'rate_this_idea': {
    'en': 'rate this idea',
    'de': 'diese Idee bewerten',
  },
  'your_rating': {
    'en': 'your rating',
    'de': 'Ihre Bewertung',
  },
  'no_ideas': {
    'en': 'press + to add new idea',
    'de': 'drücke + um eine neue Idee hinzuzufügen',
  },
  'add_new_idea': {
    'en': 'add new idea',
    'de': 'neue Idee',
  },
  'description': {
    'en': 'description',
    'de': 'Beschreibung',
  },
  'optional': {
    'en': 'optional',
    'de': 'optional',
  },
  'save': {
    'en': 'save',
    'de': 'speichern',
  },
  'date': {
    'en': 'date',
    'de': 'Datum',
  },
  'num_ratings': {
    'en': 'number of ratings',
    'de': 'Anz. Bewertungen',
  },
  'num_comments': {
    'en': 'number of comments',
    'de': 'Anz. Kommentare',
  },
  'avg_rating': {
    'en': 'average rating',
    'de': 'durchsch. Bewertung',
  },
  'author': {
    'en': 'author',
    'de': 'Autor',
  },
  'title': {
    'en': 'title',
    'de': 'Titel',
  },
  'user': {
    'en': 'user',
    'de': 'Benutzer',
  },
  'new_phase_notif_title': {
    'en': 'New Phase Started!',
    'de': 'Neue Phase gestartet!',
  },
  'new_phase_notif_body': {
    'en': 'Come back and see what\'s new',
    'de': 'Es gibt Neues zu entdecken!',
  },
  'consent_title': {
    'en': 'Declaration of Consent',
    'de': 'Einverständniserklärung',
  },
  'consent_text': {
    'en': 'I have read the information and I consent to have my data used in the manner and for the purpose indicated above.',
    'de':
        'Ich habe die Information gelesen und ich bin damit einverstanden, dass meine Daten in der oben angegebenen Weise und zu dem oben angegebenen Zweck verwendet werden.',
  },
  'sort_by': {
    'en': 'sort by',
    'de': 'sortieren nach',
  },
  'anonymous': {
    'en': 'anonymous',
    'de': 'anonym',
  },
  'consent_body': {
    'en': '''1. Introduction
In the context of my Bachelor's thesis with the title “Design, Implementation and Evaluation of a Cross-Platform Mobile Application for Experiments in Research on Electronic Brainstorming” at the Freie Universität Berlin, I (Zurab Chkhtunidze) conduct studies with participants. During these studies, I collect data which will be fully or partially represented in the thesis and also used for analyzing and improving software that is part of this work.

2. Collected data
Data that will be collected for the mention purposes may include:
- Name(s), age, occupation, place of residence and Email address of participants
- Feedback of participants, received during the studies
- Data that emerges from interaction with the software

3. Storage and Access to the data
Collected data will be stored locally and in a shared Overleaf Document, which will be accessible by me and representatives of Freie Universität Berlin who already received or will be granted access to the document by me in the context of work on the mentioned Bachelor's thesis. You can read more about the privacy policy of Overleaf on https://www.overleaf.com/legal Data that will be represented in the Bachelor's thesis and will be accessible by everyone who has access to the mentioned Bachelor's thesis. All other data will be deleted no later than 14 days after the final presentation date of the thesis.

4. Contact
For requests and questions about the collected data please contact me via Email:
zurab.tsc@gmail.com''',
    'de': '''1. Einleitung
Im Kontext meiner Bachelorarbeit mit dem Titel “Design, Implementation and Evaluation of a Cross-Platform Mobile Application for Experiments in Research on Electronic Brainstorming” an der Freien Universität Berlin führe ich (Zurab Chkhtunidze) Studien mit Teilnehmenden durch. Während diesen Studien sammle ich Daten, die vollständig oder teilweise in meiner Bachelorarbeit repräsentiert und für die Verbesserung der im Rahmen dieser Arbeit zu entwickelten Software benutzt werden.

2. Gesammelte Daten
Daten, die für oben genannten Zwecken gesammelt werden, können folgendes enthalten:
- Name(n), Alter, Beruf, und E-Mail Adresse der Teilnehmenden
- Rückmeldung der Teilnehmenden, die während der Studien gesammelt wird
- Daten, die durch Interaktion mit der Software erstellt werden

3. Speicherung und Zugriff auf die Daten Gesammelte Daten werden sowohl lokal als auch in einem geteilten Overleaf Dokument gespeichert. Den Zugriff auf dieses Dokument werden, außer mir, Angehörige der Freien Universität Berlin haben, denen ich im Kontext dieser Bachelorarbeit Zugang gewährt habe oder diesen gewähren werde. Über Datenschutz-Bestimmungen von Overleaf können Sie mehr unter dem folgenden Link erfahren: https://www.overleaf.com/legal
Daten werden außerdem in der Bachelorarbeit repräsentiert und werden daher für alle zugänglich sein, die Zugang zu der oben genannten Bachelorarbeit haben. Alle weitere Daten, die in der Bachelorarbeit nicht repräsentiert werden, werden spätestens 14 Tage nach der Präsentation der Arbeit gelöscht.

4. Kontakt
Für Anfragen über gesammelten Daten können sie mich über folgende E-Mail Adresse kontaktieren:
zurab.tsc@gmail.com
'''
  }
};

// localStr('sort_by')
String localStr(String key) {
  if (uiLanguageCode != null) {
    return localized[key][uiLanguageCode];
  } else {
    return localized[key]['en'];
  }
}

void initUiLanguage() {
  String uiLanguage = sharedPreferencesGetValue('ui_language');
  if (uiLanguage == null) {
    uiLanguageCode = 'en';
  } else {
    uiLanguageCode = uiLanguage;
  }
}
