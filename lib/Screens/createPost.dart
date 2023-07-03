import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class CreatePostScreen extends StatefulWidget {
//   @override
//   _CreatePostScreenState createState() => _CreatePostScreenState();
// }

// FirebaseFirestore db = FirebaseFirestore.instance;
// var firebaseUser = FirebaseAuth.instance.currentUser;

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   final TextEditingController _postController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Post'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _postController,
//             decoration: InputDecoration(
//               hintText: 'Enter post text',
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               FirebaseFirestore.instance.collection('posts').add({
//                 'text': _postController.text,
//               });
//               // Navigator.pop(context);
//               print(_postController.text);
//               print(firebaseUser!.uid);
//             },
//             child: Text('Create Post'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class CreatePostScreen extends StatefulWidget {
//   @override
//   _CreatePostScreenState createState() => _CreatePostScreenState();
// }

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   final TextEditingController _postController = TextEditingController();
//   File? _image;
//   var imageUrl;
//   final picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Post'),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _postController,
//             decoration: InputDecoration(
//               hintText: 'Enter post text',
//             ),
//           ),
//           TextButton(
//             onPressed: getImage,
//             child: Text('Select Image'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final Reference storageRef = FirebaseStorage.instance.ref().child(
//                   'post_images/${DateTime.now().millisecondsSinceEpoch}');
//               final UploadTask uploadTask = storageRef.putFile(_image!);
//               await uploadTask.whenComplete(() async {
//                 imageUrl = await storageRef.getDownloadURL();
//               });

//               FirebaseFirestore.instance.collection('posts').add({
//                 'text': _postController.text,
//                 'imageUrl': imageUrl,
//               });

//               // Navigator.pop(context);
//             },
//             child: Text('Create Post'),
//           ),
//         ],
//       ),
//     );
//   }
// }






 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  File? _image;

  final picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _postController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Enter post text',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(_image!),
                          if (_isUploading)
                            CircularProgressIndicator(
                              value: _uploadProgress,
                              backgroundColor: Colors.white,
                            ),
                        ],
                      ),
                    )
                  : Container(),
              
              SizedBox(height: 16.0),
              ElevatedButton.icon(
  onPressed: () async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    String imageUrl;
    if (_image != null) {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('post_images/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageRef.putFile(_image!);
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });
      await uploadTask.whenComplete(() async {
        imageUrl = await storageRef.getDownloadURL();
      });
    }
    final postData = {'text': _postController.text};
    FirebaseFirestore.instance.collection('posts').add(postData);
    setState(() {
      _isUploading = false;
    });
    // Navigator.pop(context);
  },
  icon: Icon(Icons.send),
  label: Text('Create Post'),
),
SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: getImage,
                icon: Icon(Icons.image),
                label: Text('Select Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

