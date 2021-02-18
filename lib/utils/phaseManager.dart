import 'globals.dart';

int getCurrentPhaseId(){
  if (projectInfo == null) return null;
  if (projectInfo['phases'] == null) return null;
  List projectPhases = projectInfo['phases'];
  int currentPhaseId;
  DateTime _now = DateTime.now();


  for(final e in projectPhases){
    DateTime _start = e['start_date_time'].toDate();
    DateTime _end = e['end_date_time'].toDate();
    if (_now.isAfter(_start) && _now.isBefore(_end)){
      currentPhaseId = e['phase_id'];
    }
  }
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

String getCurrentPhaseContentVisibilityValue(){
  if (projectInfo == null) return null;
  if (projectInfo['phases'] == null) return null;
  int phaseId = getCurrentPhaseId();
  String contentVisibility;

  for(final e in projectInfo['phases']){
    if (e['phase_id'] == phaseId){
      contentVisibility = e['content_visibility'];
    }
  }
  return contentVisibility;
}