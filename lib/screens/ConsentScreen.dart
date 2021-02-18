import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/components/ideasCardsList.dart';
import 'package:fu_ideation/utils/globals.dart';
import 'package:fu_ideation/utils/localization.dart';
import 'package:fu_ideation/utils/phaseManager.dart';

class ConsentScreen extends StatefulWidget {
  ConsentScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _loading = false;
  bool checkboxValue = false;

  Future<void> _next() async {
    _loading = true;
    setState(() {});
    //await Future.delayed(Duration(seconds: 5));
    sharedPreferencesSetBool('consent_granted', true);
    Navigator.pushNamedAndRemoveUntil(context, '/invitationCodeScreen', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.assignment_turned_in_outlined)],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: _loading,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                  )),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              Text(localStr('consent_title'),  textAlign: TextAlign.center),
                              Text(localStr('consent_body'), textAlign: TextAlign.justify),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                        localStr('consent_text'),
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: checkboxValue ?? false,
                      onChanged: (newValue) {
                        setState(() {
                          checkboxValue = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      onPressed: checkboxValue == false ? null : _next,
                      child: Text(
                        localStr('next'),
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Column(),
            ],
          ),
        ),
      ),
    );
  }
}
