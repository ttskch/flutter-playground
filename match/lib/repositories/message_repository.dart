import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match/models/like.dart';
import 'package:match/models/message.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';

typedef MessagesListenCallback = void Function(List<Message>);

class MessageRepository {
  final CollectionReference _collection =
      Firestore.instance.collection('messages');

  Future<List<Message>> list(User user1, User user2) async {
    Query query = _collection.orderBy('createdAt');

    // Queryで検索できるのはここまで.

    List<Message> messages = await Future.wait((await query.getDocuments())
        .documents
        .map((doc) => _fromDoc(doc))
        .toList());

    return messages
        .where((message) =>
            (message.from.id == user1.id && message.to.id == user2.id) ||
            (message.from.id == user2.id && message.to.id == user1.id))
        .toList();
  }

  // TODO: queryでor検索できないので仕方なくコレクション全体をlistenしている...
  void listen(User user1, User user2, MessagesListenCallback callback) {
    _collection.snapshots().listen((qss) async {
      callback(await list(user1, user2));
    });
  }

  Future<Message> create(User to, String body) async {
    final User me = await UserRepository().getMe();

    DocumentReference docRef = await _collection.add({
      'from': UserRepository().toDocRef(me),
      'to': UserRepository().toDocRef(to),
      'body': body,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return _fromDoc(await docRef.get());
  }

  Future<void> read(Message message) async {
    return _collection.document(message.id).updateData({
      'isRead': true,
    });
  }

  Future<Message> fromDocRef(DocumentReference docRef) async {
    return _fromDoc(await docRef.get());
  }

  DocumentReference toDocRef(Like like) {
    return _collection.document(like.id);
  }

  Future<Message> _fromDoc(DocumentSnapshot doc) async {
    if (doc.data == null) {
      return null;
    }

    return Message(
      id: doc.documentID,
      from: await UserRepository().fromDocRef(doc.data['from']),
      to: await UserRepository().fromDocRef(doc.data['to']),
      body: doc.data['body'],
      isRead: doc.data['isRead'],
      createdAt: (doc.data['createdAt'] ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> _toObject(Message message) {
    return {
      'from': UserRepository().toDocRef(message.from),
      'to': UserRepository().toDocRef(message.to),
      'body': message.body,
      'isRead': message.isRead,
    };
  }
}
