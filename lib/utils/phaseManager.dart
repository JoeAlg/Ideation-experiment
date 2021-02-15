import 'globals.dart';

int getCurrentPhaseId(){
  if (projectInfo == null) return null;
  if (projectInfo['phases'] == null) return null;
  List projectPhases = projectInfo['phases'];
  int currentPhaseId;
  DateTime _now = DateTime.now();


  for(final e in projectPhases){
    DateTime _start = e['start_date_time'].toDate();
    print('_start: ' + _start.toString());
    DateTime _end = e['end_date_time'].toDate();
    print('_end: ' + _end.toString());
    print('_now: ' + _now.toString());
    //print('_start.isAfter(_now): ' + _start.isAfter(_now).toString());
    if (_now.isAfter(_start) && _now.isBefore(_end)){
      currentPhaseId = e['phase_id'];
    }
  }
  print('##################### ' + currentPhaseId.toString());
  return currentPhaseId;
}

String getCurrentPhaseDescription(){
  if (projectInfo == null) return null;
  if (projectInfo['phases'] == null) return null;
  int phaseId = getCurrentPhaseId();
  String description;
  for(final e in projectInfo['phases']){
    if (e['phase_id'] == phaseId){
      description = e['phase_description'];
    }
  }
  return description;
}