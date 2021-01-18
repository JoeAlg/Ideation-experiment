import 'dart:ui';
import 'package:flutter/material.dart';

/*
//////////example usage for Android:
displayAlertDialog(context, 'App verlassen',
'Willst du die App verlassen?', [
['ja', SystemNavigator.pop, false],
['nein', null, true],
]);

//////////example usage for iOS:
//TODO
*/

///buttonsList is a list of values necessary for building buttons.
///It consists of lists that consist of three values:
/// 1. button text
/// 2. onclick function
/// 3. a boolean that decides if a button is primary
///when using bloc pattern call this function from listener
void displayAlertDialog(context, String titleText, String bodyText, List<List> buttonsList){
  List<FlatButton> flatButtonsList = [];
  for (List b in buttonsList) {
    Function onButtonClick = b[1];
    Color buttonTextColor = b[2] ? Colors.blue : Colors.grey;
    FlatButton newFlatButton = FlatButton(
        child: Text(b[0], style: TextStyle(color: buttonTextColor),),
        onPressed: (){
          if (onButtonClick != null){
            onButtonClick();
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
          //Navigator.of(context).pop();
        }
    );
    flatButtonsList.add(newFlatButton);
  }

  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: Text(titleText),
        content: Text(bodyText),
        actions: flatButtonsList,
      )
  );
}