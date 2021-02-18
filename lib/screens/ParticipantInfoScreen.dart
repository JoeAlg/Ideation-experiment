import 'package:flutter/material.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';
import 'package:fu_ideation/utils/localization.dart';

class ParticipantInfoScreen extends StatefulWidget {
  ParticipantInfoScreen({Key key}) : super(key: key);

  @override
  _ParticipantInfoScreenState createState() => _ParticipantInfoScreenState();
}

class _ParticipantInfoScreenState extends State<ParticipantInfoScreen> {
  void navigateToParticipantProjectScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/participantProjectScreen',
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ParticipantInfoScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lightbulb,
              size: 150,
              color: Colors.blue,
            ),
            //Text('PROJECT ID: ' + sharedPreferencesGetValue('project_id').toString()),
            Text(
              args.infoText,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 40),
            RaisedButton(child: Text(localStr('go_to_experiment')), onPressed: navigateToParticipantProjectScreen, color: Colors.blue, textColor: Colors.white),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
