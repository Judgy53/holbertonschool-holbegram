import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/Pages/methods/post_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddImage extends StatefulWidget {
  final Function setPageIndex;

  const AddImage({super.key, required this.setPageIndex});

  @override
  State<StatefulWidget> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final _captionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  Uint8List? _image;

  void _pickImage(ImageSource source, BuildContext context) async {
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });

      if(context.mounted) Navigator.pop(context);
    }
  }

  Image _buildImage() {
    if (_image == null) {
      return Image.asset("assets/images/add.png", width: 200, height: 200);
    }

    return Image.memory(_image!, width: 200, height: 200);
  }

  Future<void> _post(Users? user) async {
    if (user == null) return _showSnack("Error while creating a post: Not logged in.");
    if (_captionController.text.isEmpty) return _showSnack("Error while creating a post: Caption is empty.");
    if (_image == null) return _showSnack("Error while creating a post: No image selected.");

    String postStatus = await PostStorage().uploadPost(_captionController.text, user.uid, user.username, user.photoUrl, _image!);

    if (postStatus == "Ok") {
      _showSnack("Post Created");
      _image = null;
      _captionController.clear();
      return widget.setPageIndex(0);
    }

    return _showSnack("Error while creating a post: $postStatus");
  }

  void _showSnack(String message) {
    if(!context.mounted) return;

    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text(
                "Add Image",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
              ),
              const Spacer(),
              Consumer<UserProvider>(
                builder: (context, userProvider, _) => TextButton(
                  onPressed: () => _post(userProvider.user),
                  child: const Text(
                    "Post",
                    style: TextStyle(fontFamily: "Billabong", color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold)
                  )
                )
              )
            ],
          )
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Add Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const Text("Choose an image from your gallery or take a one.", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _captionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none
                )
              )
            ),
            const SizedBox(height: 20),
            GestureDetector(onTap: _showPickSourceModal, child: _buildImage())
          ],
        )
      )
    );
  }

    void _showPickSourceModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery, context),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color.fromARGB(255, 228, 70, 50)
                  ),
                  label: const Icon(Icons.image_outlined, color: Colors.white, size: 50)
                ),
                const SizedBox(height: 10),
                const Text("Gallery", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera, context),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color.fromARGB(255, 228, 70, 50)
                  ),
                  label: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 50)
                ),
                const SizedBox(height: 10),
                const Text("Camera", style: TextStyle(fontWeight: FontWeight.bold))
              ],
            )
          ]
        )
      )
    );
  }
}
