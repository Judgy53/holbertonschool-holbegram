import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final Timestamp datePublished;
  final String postUrl;
  final String profImage;

  Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return Post(
      caption: data["caption"] ?? "",
      uid: data["uid"] ?? "",
      username: data["username"] ?? "",
      likes: data["likes"] ?? [],
      postId: data["postId"] ?? "",
      datePublished: data["datePublished"] ?? Timestamp.now(),
      postUrl: data["postUrl"] ?? "",
      profImage: data["profImage"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "caption": caption,
    "uid": uid,
    "username": username,
    "likes": likes,
    "postId": postId,
    "datePublished": datePublished,
    "postUrl": postUrl,
    "profImage": profImage,
  };
}
