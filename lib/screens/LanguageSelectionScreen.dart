import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/components/ideasCardsList.dart';
import 'package:fu_ideation/utils/globals.dart';
import 'package:fu_ideation/utils/phaseManager.dart';

class LanguageSelectionScreen extends StatefulWidget {
  LanguageSelectionScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  bool _loading = false;

  Future<void> selectLanguage(String languageCode) async {
    _loading = true;
    setState(() {});
    //await Future.delayed(Duration(seconds: 5));
    sharedPreferencesSetString('ui_language', languageCode);
    uiLanguageCode = languageCode;
    Navigator.pushNamedAndRemoveUntil(context, '/consentScreen', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.public)],
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
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    onPressed: () => selectLanguage('en'),
                    child: Text(
                      'English',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () => selectLanguage('de'),
                    child: Text(
                      'Deutsch',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  ),
                ],
              ),
              Column(),
            ],
          ),
        ),
      ),
    );
  }
}
