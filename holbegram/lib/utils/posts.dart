import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/models/post.dart';
import 'package:holbegram/screens/Pages/methods/post_storage.dart';

class Posts extends StatefulWidget {

  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  void _deletePost(Post post) {
    PostStorage().deletePost(post.postId);
    var snackBar = const SnackBar(content: Text("Post Deleted"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("posts").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorWidget(snapshot.error!);
        if (!snapshot.hasData) return const CircularProgressIndicator();

        var data = snapshot.data!.docs;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            var post = Post.fromSnap(data[index]);

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
                    SizedBox(child: Text(post.caption)),
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
                    const Padding(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border),
                          SizedBox(width: 20),
                          Icon(Icons.chat_bubble_outline),
                          SizedBox(width: 20),
                          Icon(Icons.send),
                          Spacer(),
                          Icon(Icons.bookmark_outline)
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
