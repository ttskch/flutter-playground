import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twch/models/account.dart';
import 'package:twch/models/account_log.dart';

class Storage {
  static Future<List<Account>> getAccounts() async {
    QuerySnapshot ss = await Firestore.instance
        .collection('accounts')
        .orderBy('createdAt')
        .getDocuments();
    List<DocumentSnapshot> docs = ss.documents;

    return docs
        .map((doc) =>
            Account(id: doc.documentID, username: doc.data['username']))
        .toList();
  }

  static Future<Account> addAccount(String username) async {
    DocumentReference docRef =
        await Firestore.instance.collection('accounts').add({
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });

    DocumentSnapshot doc = await docRef.get();

    return Account(
      id: doc.documentID,
      username: username,
      createdAt: doc.data['createdAt'].toDate(),
    );
  }

  static void deleteAccount(Account account) {
    Firestore.instance.collection('accounts').document(account.id).delete();
  }

  static Future<List<AccountLog>> getAccountLogs(Account account) async {
    final DocumentReference accountRef =
        Firestore.instance.collection('accounts').document(account.id);

    QuerySnapshot ss = await Firestore.instance
        .collection('accountLogs')
        .where('account', isEqualTo: accountRef)
        .orderBy('createdAt')
        .getDocuments();
    List<DocumentSnapshot> docs = ss.documents;

    return docs
        .map((doc) => AccountLog(
              id: doc.documentID,
              followerCount: doc.data['followerCount'],
              createdAt: doc.data['createdAt'].toDate(),
            ))
        .toList();
  }

  static Future<AccountLog> addAccountLog({
    Account account,
    int followerCount,
  }) async {
    final DocumentReference accountRef =
        Firestore.instance.collection('accounts').document(account.id);

    DocumentReference docRef =
        await Firestore.instance.collection('accountLogs').add({
      'account': accountRef,
      'followerCount': followerCount,
      'createdAt': FieldValue.serverTimestamp(),
    });

    DocumentSnapshot doc = await docRef.get();

    return AccountLog(
      id: doc.documentID,
      followerCount: followerCount,
      createdAt: doc.data['createdAt'].toDate(),
    );
  }

  static void deleteAccountLog(AccountLog accountLog) {
    Firestore.instance
        .collection('accountLogs')
        .document(accountLog.id)
        .delete();
  }

  static void deleteAccountLogs(Account account) async {
    final DocumentReference accountRef =
        Firestore.instance.collection('accounts').document(account.id);

    QuerySnapshot ss = await Firestore.instance
        .collection('accountLogs')
        .where('account', isEqualTo: accountRef)
        .getDocuments();

    ss.documents.forEach((doc) => doc.reference.delete());
  }
}
