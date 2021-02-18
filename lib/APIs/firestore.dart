import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> initFirebase() async {
  await Firebase.initializeApp();
}

void initFirestore() {
  _firestore = FirebaseFirestore.instance;
}

///merges <data> into <collectionName> / <documentName>.
///if collection or document does not exist this function creates them.
///if <documentName> is null then creates a random unique document name
///for updating field in a doc use:
///  bool _success = await firestoreWrite('collectionName', 'documentName', {fieldKey : fieldValue});
Future<bool> firestoreWrite(String collectionName, String documentName, data) async {
  return await _firestore.collection(collectionName).doc(documentName).set(data, SetOptions(merge: true)).then((value) {
    print ('successfully sent to Firestore!');
    return true;
  }).catchError((e) {
    print ('ERROR sending to Firestore: ' + e.toString());
    return false;
  });
}

Future<bool> firestoreDeleteDocument(String collectionName, String documentName) async {
  return await _firestore.collection(collectionName).doc(documentName).delete().then((value) {
    print ('successfully deleted Firestore document \'' + documentName + '\' in collection \'' + collectionName + '\'');
    return true;
  }).catchError((e) {
    print ('ERROR deleting a Firestore document: ' + e.toString());
    return false;
  });
}

///adds elements into an Firestore list
Future<bool> firestoreAddToArray(String collectionName, String documentName, String arrayName, List elements) async {
  return await FirebaseFirestore.instance.collection(collectionName).doc(documentName).update({arrayName: FieldValue.arrayUnion(elements)}).then((value) {
    print ('successfully added elements to Firestore array!');
    return true;
  }).catchError((e) {
    print ('ERROR adding elements to Firestore: ' + e.toString());
    return false;
  });
}

///get document as a map from Firestore:
///usage:
///  Map myDoc = await firestoreGetDoc('collectionName', 'documentName');
Future<Map> firestoreGetDoc(String collectionName, String documentName) async {
  return await _firestore.collection(collectionName).doc(documentName).get().then((value) {
    print ('successfully got document <' + collectionName + '/' + documentName + '> from Firestore');
    return value.data();
  }).catchError((e) {
    print ('ERROR getting document from Firestore: ' + e.toString());
    return null;
  });
}

///get document field value from Firestore:
Future<dynamic> firestoreGetFieldValue(String collectionName, String documentName, fieldKey) async {
  var doc = await firestoreGetDoc(collectionName, documentName);
  return doc == null ? null : doc[fieldKey];
}