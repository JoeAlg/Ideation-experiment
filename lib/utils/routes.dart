import 'package:fu_ideation/APIs/firebaseAuth.dart';
import 'package:fu_ideation/APIs/sharedPreferences.dart';
import 'package:fu_ideation/screens/AdminProjectOverviewScreen.dart';
import 'package:fu_ideation/screens/AdminProjectsScreen.dart';
import 'package:fu_ideation/screens/ParticipantCreateIdeaScreen.dart';
import 'package:fu_ideation/screens/AdminCreateProjectScreen.dart';
import 'package:fu_ideation/screens/ParticipantIdeaOverviewScreen.dart';
import 'package:fu_ideation/screens/ParticipantInvitationCodeScreen.dart';
import 'package:fu_ideation/screens/AdminLoginScreen.dart';
import 'package:fu_ideation/screens/ParticipantInfoScreen.dart';
import 'package:fu_ideation/screens/ParticipantProjectScreen.dart';


/*
//example usage:
Navigator.pushNamed(context, '/participantProjectPage');
Navigator.pushNamedAndRemoveUntil(context, "/participantProjectPage", (r) => false);
*/

var _appRoutes = {
  '/': (context) => InvitationCodeScreen(),
  '/invitationCodeScreen': (context) => InvitationCodeScreen(),
  //////////
  '/loginScreen': (context) => LoginScreen(),
  '/createProjectScreen': (context) => CreateProjectScreen(),
  '/adminProjectsScreen': (context) => AdminProjectsScreen(),
  '/adminProjectOverviewScreen': (context) => AdminProjectOverviewScreen(),
  //////////
  '/participantInfoScreen': (context) => ParticipantInfoScreen(),
  '/participantProjectScreen': (context) => ParticipantProjectScreen(),
  '/createIdeaScreen': (context) => CreateIdeaScreen(),
  '/ideaOverviewScreen': (context) => IdeaOverviewScreen(),
};

Map getAppRoutes() {
  return _appRoutes;
}

void setInitialRoute(String newInitialRoute){
  _appRoutes['/'] = _appRoutes[newInitialRoute];
}

void initInitialRoute(){
  /*
  setInitialRoute('/invitationCodeScreen');
  return;
    */

  bool isLoggedAsAdmin = getOfflineFirebaseUser() != null; //TODO
  bool isLoggedAsParticipant = sharedPreferencesGetValue('invitation_code') != null;
  if (!isLoggedAsAdmin && !isLoggedAsParticipant){
    setInitialRoute('/invitationCodeScreen');
  } else if (isLoggedAsAdmin){
    setInitialRoute('/adminProjectsScreen');
  } else if (isLoggedAsParticipant){
    setInitialRoute('/participantProjectScreen');
  }
}