import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/users.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  // question mark is to indicate that the Uint8list? _file is empty
  Uint8List? _file;

  // these are parameters that has not been stored yet
  void postImage (
    String username,
    String uid,
    String profilepic,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadImage(
        _descriptionController.text,
        uid,
        username,
        _file!,
        profilepic,
      );
      
      if(res == "success") {
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        showSnackBar(res, context);
        setState(() {
          _isLoading = false;
        });
      }

      // this will show the erroe in the snackbar
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }
  _selectImage(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: const Text("Create a post"),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text("Take a photo"),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text("Choose from gallery"),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text("Cancel"),
            onPressed: ()  {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // MediaQuery also plays an important role in obtaining or controlling the size of the current window of the device.
    final screenSize = MediaQuery.of(context).size;
    final Users user = Provider.of<UserProvider>(context).getUser;

    // at the beginning _file is null before file is saved there so if is null it will return the first one
    return _file == null? Center(
      child: IconButton(
        onPressed: () =>  _selectImage(context),
        icon: Icon(Icons.upload),
      ),
    ) :
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: clearImage,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Post to"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(user.username, user.uid, user.photourl),
            child: const Text("Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _isLoading? const LinearProgressIndicator() : Padding(padding: EdgeInsets.only(top: 0)),
          const Divider(),
          Row(
            // Place the free space evenly between the children widget as well as half of that space before and after the first and last child widget.
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // this means that any widget in this row will start at the beginning of the ceiling
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // It is simply a circle in which we can add background color, background image, or just some text.
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photourl
                ),
              ),
              SizedBox(
                // the screensize.width is the width of the screen currently in use while the screen.width*0.4, *0.4 is 40% of the screen.width
                width: screenSize.width*0.4,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a caption....",
                    // this is to remove the border around the Text Field
                    border: InputBorder.none,
                  ),
                  // this is the amount of lines that the text field can take.
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  //this gives any widget inside this a particular dimension
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        // where this aspectratio widget is used must also use an alignment or it wont work
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
