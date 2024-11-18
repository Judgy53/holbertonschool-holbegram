import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String uid;
  late String email;
  late String username;
  late String bio;
  late String photoUrl;
  late List<dynamic> followers;
  late List<dynamic> following;
  late List<dynamic> posts;
  late List<dynamic> saved;
  late String searchKey;

  Users.fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    uid = snapshot["uid"];
    email = snapshot["email"];
    username = snapshot["username"];
    bio = snapshot["bio"];
    photoUrl = snapshot["photoUrl"];
    followers = snapshot["followers"];
    following = snapshot["following"];
    posts = snapshot["posts"];
    saved = snapshot["saved"];
    searchKey = snapshot["searchKey"];
  }

  Map<String, dynamic> toJson() =>
  {
    "uid": uid,
    "email": email,
    "username": username,
    "bio": bio,
    "photoUrl": photoUrl,
    "followers": followers,
    "following": following,
    "posts": posts,
    "saved": saved,
    "searchKey": searchKey
  };
}
