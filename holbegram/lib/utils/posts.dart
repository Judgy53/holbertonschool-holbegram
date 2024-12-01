import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/post.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/Pages/methods/post_storage.dart';
import 'package:provider/provider.dart';

class Posts extends StatefulWidget {

  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late UserProvider _loggedInUserProvider;
  Users get loggedInUser => _loggedInUserProvider.user;

  @override
  void initState() {
    super.initState();
    _loggedInUserProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void _deletePost(Post post) async {
    final deleteStatus = await PostStorage().deletePost(post, loggedInUser);

    if (mounted) {
      var snackBar = SnackBar(content: Text(deleteStatus));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool _isPostSaved(Post post) => post.likes.contains(loggedInUser.uid);

  void _toggleSavePost(Post post) {
    final postStorage = PostStorage();

    if (_isPostSaved(post)) {
      postStorage.unSavePost(post, loggedInUser);
    } else {
      postStorage.savePost(post, loggedInUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
                .collection("posts")
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
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsetsGeometry.lerp(const EdgeInsets.all(8), const EdgeInsets.all(8), 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(post.profImage),
                                fit: BoxFit.cover
                              )
                            ),
                          )
                        ),
                        Text(post.username),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _deletePost(post),
                          icon: const Icon(Icons.more_horiz)
                        ),
                      ],
                    ),
                    SizedBox(child: Text(post.caption, textAlign: TextAlign.center,)),
                    const SizedBox(height: 10),
                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: NetworkImage(post.postUrl),
                          fit: BoxFit.cover
                        )
                      )
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: _isPostSaved(post)
                                    ? const Icon(Icons.favorite, color: Colors.red)
                                    : const Icon(Icons.favorite_border),
                            onPressed: () => _toggleSavePost(post),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.chat_bubble_outline),
                          const SizedBox(width: 20),
                          const Icon(Icons.send),
                          const Spacer(),
                          const Icon(Icons.bookmark_outline)
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
                      child: Align(alignment: Alignment.centerLeft, child: Text("${post.likes.length} Liked"))
                    ),
                    const SizedBox(height: 20)
                  ],
                )
              )
            );
          },
        );
      }
    );
  }
}
