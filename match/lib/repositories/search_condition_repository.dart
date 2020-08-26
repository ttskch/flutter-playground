import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match/models/search_condition.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';

class SearchConditionRepository {
  final CollectionReference _collection =
      Firestore.instance.collection('search_conditions');

  Future<SearchCondition> get() async {
    final User me = await UserRepository().getMe();

    List<SearchCondition> conditions = await Future.wait((await _collection
            .where('owner', isEqualTo: UserRepository().toDocRef(me))
            .getDocuments())
        .documents
        .map((doc) => _fromDoc(doc))
        .toList());

    return conditions.length > 0 ? conditions.first : null;
  }

  Future<SearchCondition> upsert({
    Gender gender,
    int minAge,
    int maxAge,
    String query,
  }) async {
    final User me = await UserRepository().getMe();

    final SearchCondition condition = await get();

    DocumentReference docRef;

    if (condition != null) {
      docRef = _collection.document(condition.id);
      await docRef.setData({
        'owner': UserRepository().toDocRef(me),
        'gender': gender.toString(),
        'minAge': minAge,
        'maxAge': maxAge,
        'query': query,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      docRef = await _collection.add({
        'owner': UserRepository().toDocRef(me),
        'gender': gender.toString(),
        'minAge': minAge,
        'maxAge': maxAge,
        'query': query,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return _fromDoc(await docRef.get());
  }

  Future<SearchCondition> fromDocRef(DocumentReference docRef) async {
    return _fromDoc(await docRef.get());
  }

  Future<SearchCondition> _fromDoc(DocumentSnapshot doc) async {
    if (doc.data == null) {
      return null;
    }

    return SearchCondition(
      id: doc.documentID,
      owner: await UserRepository().fromDocRef(doc.data['owner']),
      gender: doc.data['gender'] == Gender.Man.toString()
          ? Gender.Man
          : Gender.Woman,
      minAge: doc.data['minAge'],
      maxAge: doc.data['maxAge'],
      query: doc.data['query'],
      updatedAt: (doc.data['updatedAt'] ?? Timestamp.now()).toDate(),
    );
  }
}
