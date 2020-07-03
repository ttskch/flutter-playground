import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twch/models/account.dart';

class Storage {
  static void addAccount(Account account) {
    Firestore.instance.collection('accounts').add({
      'username': account.username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
