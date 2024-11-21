import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  final ImagePicker picker = ImagePicker();

  void _pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  Image _buildImage() {
    if (_image == null) {
      return Image.asset("assets/images/Sample_User_Icon.png", width: 200, height: 200);
    }

    return Image.memory(_image!, width: 200, height: 200);
  }

  void _signUpUser() async {
    if (_image == null) {
      var snackBar = const SnackBar(content: Text("Password confirmation doesn't match"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    String authMessage = await AuthMethods.signUp(
      email: widget.email,
      password: widget.password,
      username: widget.username,
      file: _image
    );

    if (mounted) {
      var snackBar = SnackBar(content: Text('Signup: $authMessage'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              const Text(style: TextStyle(fontFamily: "Billabong", fontSize: 50), "Holbegram"),
              Image.asset("assets/images/logo.webp", width: 80, height: 60),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      "Hello, ${widget.username} Welcome to Holbegram",
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    const Text("Choose an image from your gallery or take a new one"),
                    const SizedBox(height: 24),
                    _buildImage(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.image_outlined, color: Color.fromARGB(255, 228, 70, 50)),
                          iconSize: 50,
                          onPressed : () => _pickImage(ImageSource.gallery)
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt_outlined, color: Color.fromARGB(255, 228, 70, 50)),
                          iconSize: 50,
                          onPressed : () => _pickImage(ImageSource.camera)
                        ),
                      ]
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(const Color.fromARGB(218, 226, 37, 24)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                      ),
                      onPressed: _signUpUser,
                      child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 25))
                    )
                  ],
                )
              ),
              const SizedBox(height: 28),
            ],
          )
        )
      )
    );
  }
}
