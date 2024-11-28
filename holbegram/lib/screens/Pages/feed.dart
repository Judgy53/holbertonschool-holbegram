import 'package:flutter/material.dart';
import 'package:holbegram/utils/posts.dart';

class Feed extends StatelessWidget {

  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text(style: TextStyle(fontFamily: "Billabong", fontSize: 50), "Holbegram"),
              Image.asset("assets/images/logo.webp", height: 40),
              const Spacer(),
              const Icon(Icons.add, size: 30),
              const SizedBox(width: 24),
              const Icon(Icons.chat_outlined, size: 30),
              const SizedBox(width: 24)
            ],
          )
        )
      ),
      body: const Posts()
    );
  }
}
