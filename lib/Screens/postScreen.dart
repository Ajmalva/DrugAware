import 'package:aware/Screens/createPost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// class PostScreen extends StatefulWidget {
//   @override
//   _PostScreenState createState() => _PostScreenState();
// }

// class _PostScreenState extends State<PostScreen> {
//   final TextEditingController _postController = TextEditingController();
//   File? _image;
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
//         title: Text('Posts'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('posts').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();

//                 return _buildList(context, snapshot.data!.docs);
//               },
//             ),
//           ),
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
//               String? imageUrl;
//               if (_image != null) {
//                 final Reference storageRef =
//                     FirebaseStorage.instance.ref().child('post_images/${DateTime.now().millisecondsSinceEpoch}');
//                 final UploadTask uploadTask = storageRef.putFile(_image!);
//                 await uploadTask.whenComplete(() async {
//                   imageUrl = await storageRef.getDownloadURL();
//                 });
//               }
//               FirebaseFirestore.instance.collection('posts').add({
//                 'text': _postController.text,
//                 'imageUrl': imageUrl,
//               });
//               _postController.clear();
//               setState(() {
//                 _image = null;
//               });
//             },
//             child: Text('Add Post'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//     return ListView(
//       padding: const EdgeInsets.only(top: 20.0),
//       children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//     );
//   }

//   Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//     final record = Record.fromSnapshot(data);

//     return Padding(
//       key: ValueKey(record.reference.id),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(5.0),
//         ),
//         child: ListTile(
//           title: Text(record.text),
//           trailing:
//               record.imageUrl != null ? Image.network(record.imageUrl, width: 100.0, height: 100.0) : null,
//         ),
//       ),
//     );
//   }
// }

// class Record {
//   final String text;
//   final String imageUrl;
//   final DocumentReference reference;

//   Record.fromMap(Map<String, dynamic> map, {required this.reference})
//       : assert(map['text'] != null),
//         assert(map['imageUrl'] != null),
//         text = map['text'],
//         imageUrl = map['imageUrl'];

//   Record.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data() as Map<String, dynamic>, reference: snapshot.reference);

//   @override
//   String toString() => "Record<$text:$imageUrl>";
// }

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          // print(snapshot);
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildGrid(context, snapshot.data!.docs);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemCount: snapshot.length,
      itemBuilder: (context, index) {
        final record = Record.fromSnapshot(snapshot[index]);
        return Padding(
          key: ValueKey(record.reference.id),
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  record.text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                record.imageUrl != null
                    ? Image.network(record.imageUrl,
                        width: 270.0, height: 270.0)
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class Record {
  final String text;
  final String imageUrl;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['text'] != null),
        // assert(map['imageUrl'] != null),
        text = map['text'],
        imageUrl = map['imageUrl'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()! as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Record<$text:$imageUrl>";
}
