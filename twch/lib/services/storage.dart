import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twch/models/account.dart';

class Storage {
  static Future<Account> addAccount(String username) async {
    DocumentReference doc =
        await Firestore.instance.collection('accounts').add({
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return Account(id: doc.documentID, username: username);
  }
}
