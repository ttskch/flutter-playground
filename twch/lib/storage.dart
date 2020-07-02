import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {
  static void addAccount(String username) {
    Firestore.instance.collection('accounts').add({
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
