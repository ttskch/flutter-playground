import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twch/models/account.dart';

class Storage {
  static Future<List<Account>> getAccounts() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('accounts').getDocuments();
    List<DocumentSnapshot> docs = snapshot.documents;

    return docs
        .map((doc) =>
            Account(id: doc.documentID, username: doc.data['username']))
        .toList();
  }

  static Future<Account> addAccount(String username) async {
    DocumentReference doc =
        await Firestore.instance.collection('accounts').add({
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return Account(id: doc.documentID, username: username);
  }

  static void deleteAccount(Account account) {
    Firestore.instance.collection('accounts').document(account.id).delete();
  }
}
