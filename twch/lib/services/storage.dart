import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twch/models/account.dart';
import 'package:twch/models/account_log.dart';
import 'package:twch/services/auth.dart';

typedef AccountsListenCallback = void Function(List<Account>);
typedef AccountLogsListenCallback = void Function(List<AccountLog>);

class Storage {
  static Firestore _firestore = Firestore.instance;

  static Future<DocumentReference> get _baseDocument async {
    final String uid = (await Auth.getCurrentUser()).uid;
    return _firestore.document('users/$uid');
  }

  static void getAccounts(AccountsListenCallback callback) async {
    (await _baseDocument)
        .collection('accounts')
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
    (await _baseDocument).collection('accounts').add({
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static void deleteAccount(Account account) async {
    (await _baseDocument).collection('accounts').document(account.id).delete();
    Storage.deleteAccountLogs(account);
  }

  static void getAccountLogs(
      Account account, AccountLogsListenCallback callback) async {
    final DocumentReference accountRef =
        (await _baseDocument).collection('accounts').document(account.id);

    (await _baseDocument)
        .collection('accountLogs')
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
    final DocumentReference accountRef =
        (await _baseDocument).collection('accounts').document(account.id);

    (await _baseDocument).collection('accountLogs').add({
      'account': accountRef,
      'followerCount': followerCount,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static void deleteAccountLog(AccountLog accountLog) async {
    (await _baseDocument)
        .collection('accountLogs')
        .document(accountLog.id)
        .delete();
  }

  static void deleteAccountLogs(Account account) async {
    final DocumentReference accountRef =
        (await _baseDocument).collection('accounts').document(account.id);

    QuerySnapshot ss = await (await _baseDocument)
        .collection('accountLogs')
        .where('account', isEqualTo: accountRef)
        .getDocuments();

    ss.documents.forEach((doc) => doc.reference.delete());
  }
}
