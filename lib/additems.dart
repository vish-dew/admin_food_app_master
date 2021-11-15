import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class AddItems extends StatefulWidget {
  const AddItems({Key? key}) : super(key: key);

  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController foodname = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();

  // String photoUrl = "";
  // late File imageFile;
  // final _picker = ImagePicker();

  bool isLoading = false;
  // Future gettingImage() async {
  //   PickedFile? image = await _picker.getImage(source: ImageSource.gallery);

  //   if (image != null) {
  //     isLoading = true;
  //     this.imageFile = File(image.path);
  //   }
  //   uploadImageToFirebace();
  // }
  File? image;
  UploadTask? task;
  String photoUrl = "";
  Future pickImage() async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemprary = File(image.path);
      setState(() {
        this.image = imageTemprary;
      });
      // uploadImageToFirebace();
    } on PlatformException catch (e) {
      // TODO
      print("Failed to pick image: $e");
    }
  }

  // Future uploadfile() async {
  //   if (image == null) return;
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference reference =
  //       FirebaseStorage.instance.ref().child("Food").child(fileName);
  // }

  Future uploadImageToFirebace() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child("Foods").child(fileName);
    UploadTask uploadTask = ref.putFile(image!);
    TaskSnapshot storageTaskSnapshot = await uploadTask;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      photoUrl = downloadUrl;
      FirebaseFirestore.instance.collection("Food").doc().set({
        'foodname': foodname.text,
        'price': price.text,
        'quantity': quantity.text,
        'photoUrl': photoUrl,
        'time': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          titleSpacing: 2.0,
          title: Text("Add Items"),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        (image == null)
                            ?
                            // ? (photoUrl != "")

                            Center(
                                child: Icon(Icons.camera_alt,
                                    size: 200.0, color: Colors.grey),
                              )
                            : Material(
                                // display new iamge
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Image.file(
                                      image!,
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(125.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              size: 100.0,
                              color: Colors.white54.withOpacity(0.3),
                            ),
                            onPressed: pickImage,
                            padding: EdgeInsets.all(0.0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.grey,
                            iconSize: 200.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: isLoading
                            ? CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lightBlueAccent),
                              )
                            : Container(),
                      ),
                      Container(
                        child: Text(
                          "Food Name:",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.lightBlueAccent),
                          child: TextField(
                            controller: foodname,
                            decoration: InputDecoration(
                              hintText: "Enter food iteam name",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      ),
                      Container(
                        child: Text(
                          "Quantity:",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.lightBlueAccent),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter the amount",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            controller: quantity,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      ),
                      Container(
                        child: Text(
                          "Price:",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Colors.lightBlueAccent),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter the price",
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            controller: price,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 145),
                        child: GestureDetector(
                          onTap: () {
                            final String fname = foodname.text.trim();
                            final String quan = quantity.text.trim();
                            final String pri = price.text.trim();
                            if (fname.isEmpty) {
                              Text("Food Name is Empty");
                            } else if (quan.isEmpty) {
                              print("Quantity is Empty");
                            } else if (pri.isEmpty) {
                              print("Price is Empty");
                            } else {
                              uploadImageToFirebace();
                            }
                          },
                          child: FlatButton(
                              color: Colors.deepPurple,
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Text(
                                '  Upload Data  ',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
