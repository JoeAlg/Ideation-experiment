import 'package:flutter/material.dart';
import 'package:fu_ideation/utils/routes.dart';
import 'APIs/firestore.dart';
import 'APIs/sharedPreferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  initFirestore();
  await initSharedPreferences();
  initInitialRoute();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: getAppRoutes(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
