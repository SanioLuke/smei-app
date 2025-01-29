import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dependencies extends GetxService {

  DocumentReference<Map> userEntryDataRef() {
    return FirebaseFirestore.instance
        .collection('user_entry_data')
        .doc(FirebaseAuth.instance.currentUser!.uid);      
  }
}
