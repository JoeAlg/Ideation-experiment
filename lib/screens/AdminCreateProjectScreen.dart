import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/utils/dateTimeFormatter.dart';
import 'package:fu_ideation/utils/linearCongruentialGenerator.dart';
import 'package:fu_ideation/utils/onlineDatabase.dart';

class CreateProjectScreen extends StatefulWidget {
  CreateProjectScreen({Key key}) : super(key: key);

  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  bool progressIndicatorVisible = false;

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController numParticipantsController = new TextEditingController();
  DateTime selectedStartDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();

  Future<void> onSaveProjectButtonClicked() async {
    FocusScope.of(context).unfocus();
    if (progressIndicatorVisible) return;
    String projectTitle = titleController.text;
    if (projectTitle == '') return;
    String projectDescription = descriptionController.text;
    if (projectDescription == '') return;

    progressIndicatorVisible = true;
    setState(() {});

    int numParticipants;
    try {
      numParticipants = int.parse(numParticipantsController.text);
    } catch (e) {
      print('error: ' + e.toString());
      return;
    }


    int projectId = await generateNewProjectIdOverFirestore();
    Map invitationCodes = await generateNewInvitationCodesOverFirestore(projectId, numParticipants);
    if (invitationCodes == null) {
      print('generateNewInvitationCodesOverFirestore() ERROR');
      return;
    }

    Map participants = {};
    invitationCodes.forEach((k, v) {
      participants[k] = {
        'invitation_code' : k,
        'name' : 'unknown',
        'email' : 'unknown',
        'app_launches' : [],
        'status' : 'code_not_activated',
        'invitation_code_activated' : 'null',
      };
    });

    var projectMap = {
      'project_id': projectId,
      'title': projectTitle,
      'description': projectDescription,
      'author': 'unknown',
      'created_on': DateTime.now(),
      'starts': selectedStartDateTime,
      'ends': selectedEndDateTime,
      'status': 'active',
      'idea_id_counter' : 0,
      'participants' : participants,
    };

    bool _success = await firestoreWrite('_projects_data', 'project_' + projectId.toString(), projectMap);
    if (_success) {
      Navigator.pushNamedAndRemoveUntil(context, "/adminProjectsScreen", (r) => false);
      progressIndicatorVisible = true;
    } else {
      print('firestoreWrite() ERROR');
      return;
    }
  }

  Future<void> _selectDate(BuildContext context, _dateTime) async {
    FocusScope.of(context).unfocus();
    final DateTime pickedDate = await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(2020, 1), lastDate: DateTime(2101));
    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute));
      if (pickedTime != null) {
        setState(() {
          selectedStartDateTime = new DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create project'),
      ),
      //TODO use SafeArea on every page
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'project title:',
                ),
              ),
              TextField(
                controller: titleController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'title...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
              ),

              //description
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                child: Text(
                  'description:',
                ),
              ),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.emailAddress,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'description...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
              ),

              //number of participants
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                child: Text(
                  'number of participants:',
                ),
              ),
              TextField(
                controller: numParticipantsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'ex. 10',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
              ),

              //start
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('starts:'),
                    FlatButton(
                      onPressed: () => _selectDate(context, selectedStartDateTime),
                      child: Text(
                        dateTimeToString(selectedStartDateTime),
                        style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              //end
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ends:'),
                    FlatButton(
                      onPressed: () => _selectDate(context, selectedEndDateTime),
                      child: Text(
                        dateTimeToString(selectedEndDateTime),
                        style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              RaisedButton(
                child: progressIndicatorVisible
                    ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text('save', style: TextStyle(color: Colors.white)),
                onPressed: onSaveProjectButtonClicked,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
