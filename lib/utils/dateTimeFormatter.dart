import 'package:fu_ideation/APIs/sharedPreferences.dart';

String dateTimeToString(DateTime _datetime) {
  String s = _datetime.day.toString().padLeft(2, '0') + '.';
  s = s + _datetime.month.toString().padLeft(2, '0') + '.';
  s = s + _datetime.year.toString() + ' ';
  s = s + _datetime.hour.toString().padLeft(2, '0') + ':';
  s = s + _datetime.minute.toString().padLeft(2, '0');
  return s;
}

String dateTimeToAgoString(DateTime _datetime) {
  Duration difference = DateTime.now().difference(_datetime);
  int _years = difference.inDays ~/ 360;
  int _months = difference.inDays ~/ 30;
  int _days = difference.inDays;
  int _hours = difference.inHours;
  int _minutes = difference.inMinutes;
  int _seconds = difference.inSeconds;


  String uiLanguage = sharedPreferencesGetValue('ui_language');
  if (uiLanguage == null) uiLanguage = 'en';
  if (uiLanguage == 'de'){
    if (_years != 0) return 'vor ' + _years.toString() + ((_years == 1) ? ' Jahr' : ' Jahren');
    if (_months != 0) return 'vor ' + _months.toString() + ((_months == 1) ? ' Monat' : ' Monaten');
    if (_days != 0) return 'vor ' + _days.toString() + ((_days == 1) ? ' Tag' : ' Tagen');
    if (_hours != 0) return 'vor ' + _hours.toString() + ((_hours == 1) ? ' Stunde' : ' Stunden');
    if (_minutes != 0) return 'vor ' + _minutes.toString() + ((_minutes == 1) ? ' Minute' : ' Minuten');
    //if(_seconds != 0) return _seconds.toString() + ((_seconds == 1) ? ' second ago' : ' seconds ago');
    return 'vor Kurzem';
  } else {
    if (_years != 0) return _years.toString() + ((_years == 1) ? ' year ago' : ' years ago');
    if (_months != 0) return _months.toString() + ((_months == 1) ? ' month ago' : ' months ago');
    if (_days != 0) return _days.toString() + ((_days == 1) ? ' day ago' : ' days ago');
    if (_hours != 0) return _hours.toString() + ((_hours == 1) ? ' hour ago' : ' hours ago');
    if (_minutes != 0) return _minutes.toString() + ((_minutes == 1) ? ' minute ago' : ' minutes ago');
    //if(_seconds != 0) return _seconds.toString() + ((_seconds == 1) ? ' second ago' : ' seconds ago');
    return 'just now';
  }

}
