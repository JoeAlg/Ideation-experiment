String dateTimeToString(DateTime _datetime){
  String s = _datetime.day.toString().padLeft(2,'0') + '.';
  s = s + _datetime.month.toString().padLeft(2,'0') + '.';
  s = s +  _datetime.year.toString() + ' ';
  s = s +  _datetime.hour.toString().padLeft(2,'0') + ':';
  s = s +  _datetime.hour.toString().padLeft(2,'0');
  return s;
}