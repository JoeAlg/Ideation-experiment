import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
UserCredential userCredential;


User getOfflineFirebaseUser() {
  if (_auth == null){
    return null;
  }
  return _auth.currentUser;
}


Future<void> signInWithEmailAndPassword(String emailString, String passwordString) async {
  try {
    userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailString, password: passwordString);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print ('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print ('Wrong password provided for that user.');
    }
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  return;
}