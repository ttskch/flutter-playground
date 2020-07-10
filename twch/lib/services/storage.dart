import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twch/models/account.dart';
import 'package:twch/models/account_log.dart';
import 'package:twch/services/auth.dart';

typedef AccountsListenCallback = void Function(List<Account>);
typedef AccountLogsListenCallback = void Function(List<AccountLog>);

class Storage {
  static Firestore _firestore = Firestore.instance;

  static Future<String> get _userId async {
    return (await Auth.getCurrentUser()).uid;
  }

  static void getAccounts(AccountsListenCallback callback) async {
    _firestore
        .collection('users/${await _userId}/accounts')
        .orderBy('createdAt')
        .snapshots()
        .listen((QuerySnapshot ss) {
      List<DocumentSnapshot> docs = ss.documents;
      final accounts = docs.map((doc) {
        return Account(
          id: doc.documentID,
          username: doc.data['username'],
          // 新規作成要求直後に一度createdAtがnullの状態で呼ばれて、永続化完了後にcreatedAtに値が入った状態で再度呼ばれる.
          createdAt: (doc.data['createdAt'] ?? Timestamp.now()).toDate(),
        );
      }).toList();
      callback(accounts);
    });
  }

  static void addAccount(String username) async {
    _firestore.collection('/users/${await _userId}/accounts').add({
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static void deleteAccount(Account account) async {
    _firestore
        .collection('/users/${await _userId}/accounts')
        .document(account.id)
        .delete();
    Storage.deleteAccountLogs(account);
  }

  static void getAccountLogs(
      Account account, AccountLogsListenCallback callback) async {
    final DocumentReference accountRef = _firestore
        .collection('/users/${await _userId}/accounts')
        .document(account.id);

    _firestore
        .collection('/users/${await _userId}/accountLogs')
        .where('account', isEqualTo: accountRef)
        .orderBy('createdAt')
        .snapshots()
        .listen((QuerySnapshot ss) {
      List<DocumentSnapshot> docs = ss.documents;
      final accountLogs = docs.map((doc) {
        return AccountLog(
          id: doc.documentID,
          followerCount: doc.data['followerCount'],
          // 新規作成要求直後に一度createdAtがnullの状態で呼ばれて、永続化完了後にcreatedAtに値が入った状態で再度呼ばれる.
          createdAt: (doc.data['createdAt'] ?? Timestamp.now()).toDate(),
        );
      }).toList();
      callback(accountLogs);
    });
  }

  static void addAccountLog({
    Account account,
    int followerCount,
  }) async {
    final DocumentReference accountRef = _firestore
        .collection('/users/${await _userId}/accounts')
        .document(account.id);

    _firestore.collection('/users/${await _userId}/accountLogs').add({
      'account': accountRef,
      'followerCount': followerCount,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static void deleteAccountLog(AccountLog accountLog) async {
    _firestore
        .collection('/users/${await _userId}/accountLogs')
        .document(accountLog.id)
        .delete();
  }

  static void deleteAccountLogs(Account account) async {
    final DocumentReference accountRef = _firestore
        .collection('/users/${await _userId}/accounts')
        .document(account.id);

    QuerySnapshot ss = await _firestore
        .collection('/users/${await _userId}/accountLogs')
        .where('account', isEqualTo: accountRef)
        .getDocuments();

    ss.documents.forEach((doc) => doc.reference.delete());
  }
}
