import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class StorageMethods {
  static const childProfilePhotos = "profilePhotos";
  static const usePicSum = true;

  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String> uploadImageToStorage(bool isPost, String childName, Uint8List file) async {
    if (usePicSum) return generatePicsumImage();

    Reference ref =_storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static String generatePicsumImage() {
    String id = const Uuid().v1();
    return "https://picsum.photos/seed/$id/350";
  }
}
