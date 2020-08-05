import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'auth.dart';

class Storage {
  final String _dirName = 'iamges';

  Future<String> upload(File file) async {
    if (file == null) {
      return null;
    }

    final StorageReference ref = FirebaseStorage()
        .ref()
        .child(await Auth().getCurrentUserId())
        .child(_dirName)
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    final StorageUploadTask uploadTask = ref.putFile(file);

    StorageTaskSnapshot ss = await uploadTask.onComplete;

    if (ss.error != null) {
      throw Exception('Failed to upload');
    }

    return await ss.ref.getDownloadURL();
  }
}
