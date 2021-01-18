import 'package:flutter/material.dart';
import 'package:fu_ideation/components/projectLiveDetails.dart';
import 'package:fu_ideation/utils/ScreenArguments.dart';

//TODO https://stackoverflow.com/a/55885760
class AdminProjectOverviewScreen extends StatefulWidget {
  AdminProjectOverviewScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AdminProjectOverviewScreenState createState() => _AdminProjectOverviewScreenState();
}

class _AdminProjectOverviewScreenState extends State<AdminProjectOverviewScreen> {
  void navigateToCreateProjectScreen() {
    Navigator.pushNamed(context, '/createProjectScreen');
  }

  @override
  Widget build(BuildContext context) {
    final ProjectOverviewScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.projectId.toString()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text('project: ' + args.projectId.toString()),
              ProjectsLiveDetails(args.projectId),
              //InviteCodesList(),
            ],
          ),
        ),
      ),
    );
  }
}
