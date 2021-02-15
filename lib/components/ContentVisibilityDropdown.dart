import 'package:flutter/material.dart';
import 'package:fu_ideation/utils/globals.dart';

class ContentVisibilityDropdown extends StatefulWidget {
  @override
  _ContentVisibilityDropdownState createState() => _ContentVisibilityDropdownState();
}

class _ContentVisibilityDropdownState extends State<ContentVisibilityDropdown> {
  @override
  Widget build(BuildContext context) {
    return new DropdownButton(
        value: selectedPhasesDropDownValue,
        items: [
          DropdownMenuItem(value: 'visible', child: Text('visible')),
          DropdownMenuItem(value: 'Pseudonymized', child: Text('Pseudonymized')),
          DropdownMenuItem(value: 'anonymized', child: Text('anonymized')),
          DropdownMenuItem(value: 'hidden', child: Text('hidden')),
        ],
        onChanged: (value) {
          print(value.toString());
          setState(() {
            selectedPhasesDropDownValue = value;
          });
        });
  }
}
