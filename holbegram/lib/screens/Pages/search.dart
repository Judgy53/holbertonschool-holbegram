import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:holbegram/models/post.dart';

class Search extends StatefulWidget {

  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextFormField(
            controller: _searchTextController,
            textCapitalization: TextCapitalization.none,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_outlined),
              hintText: "Search",
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              filled: true,
              fillColor: Color.fromARGB(64, 128, 128, 128)
            )
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: ListenableBuilder(
          listenable: _searchTextController,
          builder: (context, child) => StreamBuilder(
            stream: FirebaseFirestore.instance
                      .collection("posts")
                      .orderBy("datePublished")
                      .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return ErrorWidget(snapshot.error!);
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final data = snapshot.data!.docs.map((element) => Post.fromSnap(element)).toList();

              if (_searchTextController.text.isNotEmpty) {
                final search = _searchTextController.text.toLowerCase();
                data.retainWhere((element) => element.caption.toLowerCase().contains(search));
              }

              return GridView.custom(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  repeatPattern: QuiltedGridRepeatPattern.same,
                  pattern: const [
                    QuiltedGridTile(2, 2),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  childCount: data.length,
                  (context, index) {
                    final post = data[index];

                    return Image.network(post.postUrl, fit: BoxFit.cover);
                  },
                ),
              );
            }
          ),
        )
      )
    );
  }
}
