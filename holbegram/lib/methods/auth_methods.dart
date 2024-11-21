import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holbegram/models/user.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) return "Please fill all the fields";

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") return "No account found with this email and password";

      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> signUp({required String email, required String password, required String username, Uint8List? file}) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) return "Please fill all the fields";

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      if (user == null) return 'User creation failed';

      /* DISABLED BECAUSE FIREBASE PRICING CHANGE */
      //String photoURL = file != null ? await StorageMethods.uploadImageToStorage(false, StorageMethods.childProfilePhotos, file) : "";

      Users userModel = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: "",
        photoUrl: "", // photoURL
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username[0]
      );

      await _firestore.collection("users").doc(user.uid).set(userModel.toJson());

      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "The account already exists for that email.";
      }
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
