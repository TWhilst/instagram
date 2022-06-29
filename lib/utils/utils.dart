import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// this is a function that allows us to select an image when the add an image icon is clicked on
// the function takes in a parameter of the variable ImageSource named source
pickImage(ImageSource source) async {
  // this is the imported class of the image_picker
  final ImagePicker _imagepicker = ImagePicker();

  // _imagepicker.pickImage(source: source) is the property from the class that is used to pick an image and it's of the type XFile
  XFile? _file = await _imagepicker.pickImage(source: source);
  // this is saying that if an image is not selected do  this
  if(_file != null){
    // it will return the image and this will return uint8list
    return await _file.readAsBytes();
  }else{
    print("No image selected");
  }

}

// this snackbar is used to show if there was an error when running the user details to the firebase autentication and database
showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}