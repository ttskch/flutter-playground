import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match/models/like.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:meta/meta.dart';

typedef LikesListenCallback = void Function(List<Like>);

class LikeRepository {
  final CollectionReference _collection =
      Firestore.instance.collection('likes');

  Future<List<Like>> list({
    User from,
    User to,
  }) async {
    if (from == null && to == null) {
      throw ArgumentError('fromまたはtoのいずれかは必須です');
    }

    Query query = _collection.orderBy('createdAt');

    if (from != null) {
      query = query.where('from', isEqualTo: UserRepository().toDocRef(from));
    }

    if (to != null) {
      query = query.where('to', isEqualTo: UserRepository().toDocRef(to));
    }

    return Future.wait((await query.getDocuments())
        .documents
        .map((doc) => _fromDoc(doc))
        .toList());
  }

  void listen({
    @required LikesListenCallback callback,
    User from,
    User to,
  }) {
    if (from == null && to == null) {
      throw ArgumentError('fromまたはtoのいずれかは必須です');
    }

    Query query = _collection.orderBy('createdAt');

    if (from != null) {
      query = query.where('from', isEqualTo: UserRepository().toDocRef(from));
    }

    if (to != null) {
      query = query.where('to', isEqualTo: UserRepository().toDocRef(to));
    }

    query.snapshots().listen((qss) async {
      final List<Like> likes =
          await Future.wait(qss.documents.map((doc) => _fromDoc(doc)).toList());
      callback(likes);
    });
  }

  Future<Like> create(User to) async {
    final User me = await UserRepository().getMe();

    DocumentReference docRef = await _collection.add({
      'from': UserRepository().toDocRef(me),
      'to': UserRepository().toDocRef(to),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return _fromDoc(await docRef.get());
  }

  Future<void> update(Like like) async {
    return _collection.document(like.id).updateData(_toObject(like));
  }

  Future<Like> fromDocRef(DocumentReference docRef) async {
    return _fromDoc(await docRef.get());
  }

  DocumentReference toDocRef(Like like) {
    return _collection.document(like.id);
  }

  Future<Like> _fromDoc(DocumentSnapshot doc) async {
    if (doc.data == null) {
      return null;
    }

    return Like(
      id: doc.documentID,
      from: await UserRepository().fromDocRef(doc.data['from']),
      to: await UserRepository().fromDocRef(doc.data['to']),
      matchedAt:
          doc.data['matchedAt'] == null ? null : doc.data['matchedAt'].toDate(),
      createdAt: (doc.data['createdAt'] ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> _toObject(Like like) {
    return {
      'from': UserRepository().toDocRef(like.from),
      'to': UserRepository().toDocRef(like.to),
      'matchedAt': Timestamp.fromDate(like.matchedAt),
    };
  }
}
