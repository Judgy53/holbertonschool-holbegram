import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/post.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Favorite extends StatelessWidget {

  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(style: TextStyle(fontFamily: "Billabong", fontSize: 50), " Favorites")
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.user as Users;
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                      .collection("posts")
                      .where("likes", arrayContains: user.uid)
                      .orderBy("datePublished", descending: true)
                      .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return ErrorWidget(snapshot.error!);
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final data = snapshot.data!.docs.map((element) => Post.fromSnap(element)).toList();

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final post = data[index];

                  return Image.network(post.postUrl);
                },
              );
            }
          );
        }
      )
    );
  }
}
