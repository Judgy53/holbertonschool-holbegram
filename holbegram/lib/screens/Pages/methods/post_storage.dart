import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/methods/storage_methods.dart';
import 'package:holbegram/models/post.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String caption, String uid, String username, String profImage, Uint8List image) async {
    try {
      String postURL = await StorageMethods.uploadImageToStorage(true, "posts", image);

      String postId = _firestore.collection("posts").doc().id;
      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: Timestamp.now(),
        postUrl: postURL,
        profImage: profImage
      );

      await _firestore.collection("posts").doc(postId).set(post.toJson());

      await _firestore.collection("users").doc(uid).update({
        "posts": FieldValue.arrayUnion([postId])
      });

      return "Ok";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePost(String postId) {
    return _firestore.collection("posts").doc(postId).delete();
  }
}
