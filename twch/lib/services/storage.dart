import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twch/models/account.dart';
import 'package:twch/models/account_log.dart';

class Storage {
  static Future<List<Account>> getAccounts() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('accounts')
        .orderBy('createdAt')
        .getDocuments();
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

  static Future<List<AccountLog>> getAccountLogs(Account account) async {
    final DocumentReference accountReference =
        Firestore.instance.collection('accounts').document(account.id);

    QuerySnapshot snapshot = await Firestore.instance
        .collection('accountLogs')
        .where('account', isEqualTo: accountReference)
        .orderBy('createdAt')
        .getDocuments();
    List<DocumentSnapshot> docs = snapshot.documents;

    return docs
        .map((doc) => AccountLog(
            id: doc.documentID,
            followerCount: doc.data['followerCount'],
            dateTime: doc.data['dateTime'].toDate()))
        .toList();
  }

  static Future<AccountLog> addAccountLog(
      {Account account, int followerCount, DateTime dateTime}) async {
    final DocumentReference accountReference =
        Firestore.instance.collection('accounts').document(account.id);

    DocumentReference doc =
        await Firestore.instance.collection('accountLogs').add({
      'account': accountReference,
      'followerCount': followerCount,
      'dateTime': dateTime,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return AccountLog(
        id: doc.documentID, followerCount: followerCount, dateTime: dateTime);
  }

  static void deleteAccountLog(AccountLog accountLog) {
    Firestore.instance
        .collection('accountLogs')
        .document(accountLog.id)
        .delete();
  }

  static void deleteAccountLogs(Account account) async {
    final DocumentReference accountReference =
        Firestore.instance.collection('accounts').document(account.id);

    QuerySnapshot snapshot = await Firestore.instance
        .collection('accountLogs')
        .where('account', isEqualTo: accountReference)
        .getDocuments();

    snapshot.documents
        .forEach((documentSnapshot) => documentSnapshot.reference.delete());
  }
}
