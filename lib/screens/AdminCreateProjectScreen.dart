import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/firestore.dart';
import 'package:fu_ideation/components/ContentVisibilityDropdown.dart';
import 'package:fu_ideation/utils/dateTimeFormatter.dart';
import 'package:fu_ideation/utils/globals.dart';
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
  TextEditingController participantNamesController = new TextEditingController();
  TextEditingController phaseDescriptionController = new TextEditingController();
  DateTime selectedStartDateTime = DateTime.now();
  DateTime selectedEndDateTime = DateTime.now();
  DateTime selectedPhaseStartDateTime = DateTime.now();
  DateTime selectedPhaseEndDateTime = DateTime.now();
  List<Map> phasesMaps = [];
  String _phasesDropDownSelection;
  bool checkedValue = false;
  bool customNameSelectionCheckboxValue = false;

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
      return;
    }

    int projectId = await generateNewProjectIdOverFirestore();
    Map invitationCodes = await generateNewInvitationCodesOverFirestore(projectId, numParticipants);
    if (invitationCodes == null) {
      return;
    }

    Map participants = {};
    int i = 1;
    invitationCodes.forEach((k, v) {
      participants[k] = {
        'invitation_code': k,
        'name': 'unknown',
        'pseudonym' : i.toString(),
        'email': 'unknown',
        'app_launches': [],
        'status': 'code_not_activated',
        'invitation_code_activated': 'null',
      };
      i++;
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
      'idea_id_counter': 0,
      'participants': participants,
      'phases' : phasesMaps,
    };

    bool _success = await firestoreWrite('_projects_data', 'project_' + projectId.toString(), projectMap);
    if (_success) {
      Navigator.pushNamedAndRemoveUntil(context, "/adminProjectsScreen", (r) => false);
      progressIndicatorVisible = true;
    } else {
      print ('firestoreWrite() ERROR');
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

  Future<void> _selectPhaseDate(BuildContext context, _dateTime) async {
    FocusScope.of(context).unfocus();
    final DateTime pickedDate = await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(2020, 1), lastDate: DateTime(2101));
    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute));
      if (pickedTime != null) {
        setState(() {
          selectedPhaseStartDateTime = new DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  void _savePhase() {
    Navigator.of(context, rootNavigator: true).pop();
    lastPhaseId += 1;
    Map _phaseMap = {
      'phase_id': lastPhaseId,
      'start_date_time': selectedPhaseStartDateTime,
      'end_date_time': selectedPhaseEndDateTime,
      'content_visibility': selectedPhasesDropDownValue,
      'phase_description': phaseDescriptionController.text,
    };
    phasesMaps.add(_phaseMap);
    setState(() {});
  }

  void _addPhase() {
    selectedPhasesDropDownValue = 'visible';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        SizedBox(height: 20),
                        Text('create new phase', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                        SizedBox(height: 20),
                        Text(_phasesDropDownSelection ?? 'co-participants content visibility:'),
                        Row(
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            ContentVisibilityDropdown(),
                          ],
                        ),
                        SizedBox(height: 20),
                        //start
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('starts:'),
                            FlatButton(
                              onPressed: () => _selectPhaseDate(context, selectedPhaseStartDateTime),
                              child: Text(
                                dateTimeToString(selectedPhaseStartDateTime),
                                style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        //end
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('ends:'),
                            FlatButton(
                              onPressed: () => _selectPhaseDate(context, selectedPhaseEndDateTime),
                              child: Text(
                                dateTimeToString(selectedPhaseEndDateTime),
                                style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: phaseDescriptionController,
                          keyboardType: TextInputType.emailAddress,
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: 'description...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              )),
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          onPressed: _savePhase,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'save',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          color: Colors.blue,
                        ),
                        SizedBox(height: 20),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _phases() {
    if (1 == 2) {
      return Column(
        children: [
          Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('8'),
                    Text('87'),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    if (phasesMaps == null || phasesMaps.isEmpty) {
      return Container();
    }
    List<Widget> phasesElements = [];
    for (final e in phasesMaps) {
      phasesElements.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Phase ' + e['phase_id'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Text('content visibility: ' + e['content_visibility']),
              Text('starts: ' + dateTimeToString(e['start_date_time'])),
              Text('ends: ' + dateTimeToString(e['end_date_time'])),
            ],
          ),
        ),
      ));
    }
    Column phasesColumn = new Column(children: phasesElements);
    return phasesColumn;
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
                //keyboardType: TextInputType.emailAddress,
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
                  'welcome text:',
                ),
              ),
              TextField(
                controller: descriptionController,
                //keyboardType: TextInputType.emailAddress,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: 'welcome to this project...',
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

              //number of participants
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                child: Text(
                  'participant names (one per line):',
                ),
              ),
              TextField(
                controller: participantNamesController,
                minLines: 5,
                maxLines: 6,
                decoration: InputDecoration(
                    hintText: 'Alice\nBob',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
              ),

              SizedBox(height: 18),
              //start
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('starts:'),
                  FlatButton(
                    onPressed: () => _selectDate(context, selectedStartDateTime),
                    child: Text(
                      '!: ' + dateTimeToString(selectedStartDateTime),
                      style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                    ),
                  ),
                ],
              ),

              //end
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ends:'),
                  FlatButton(
                    onPressed: () => _selectDate(context, selectedEndDateTime),
                    child: Text(
                      '*: ' + dateTimeToString(selectedEndDateTime),
                      style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                    ),
                  ),
                ],
              ),

              CheckboxListTile(
                title: Text("let participants edit their names"),
                value: customNameSelectionCheckboxValue ?? false,
                onChanged: (newValue) {
                  setState(() {
                    customNameSelectionCheckboxValue = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),

              _phases(),

              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text('add phase'),
                    onPressed: _addPhase,
                    //color: Colors.blue,
                  ),
                ],
              ),

              SizedBox(height: 18),

              RaisedButton(
                child: progressIndicatorVisible
                    ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text('save', style: TextStyle(color: Colors.white)),
                onPressed: onSaveProjectButtonClicked,
                color: Colors.blue,
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
