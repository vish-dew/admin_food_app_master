import 'package:admin_food_app/additems.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Food').snapshots();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Admin Panel"),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Icon(Icons.logout),
              ),
            )
            // ElevatedButton.icon(
            //     onPressed: () {
            //       FirebaseAuth.instance.signOut();
            //     },
            //     icon: Icon(
            //       Icons.logout,
            //     ),
            //     label: Text(
            //       "",
            //       style: TextStyle(color: Colors.deepPurple),
            //     ))
          ],
        ),
        body: StreamBuilder(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color?>(Colors.blue[900]),
                ),
              );
            } else {
              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        offset: Offset(0, 0.5),
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        // decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10)),
                        width: 142,
                        height: 200,
                        child: Image(
                            image:
                                CachedNetworkImageProvider(data['photoUrl'])),
                      ),
                      Container(
                        child: Column(
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: 'Food Name:    ',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: '${data['fooname']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ])),
                            RichText(
                                text: TextSpan(
                                    text: 'Price:    ',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: '\u20A8 ${data['price']}.00',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ])),
                            RichText(
                                text: TextSpan(
                                    text: 'Quantity:     ',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: '${data['quantity']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ])),
                            // Text(
                            //   "Food Name: ${data['fooname']}",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                            // Text(
                            //   "Price: ${data['price']}",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                            // Text(
                            //   "Quantity: ${data['quantity']}",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
                          // return Container(
                          //   child: Text(data["price"]),
                          // );
                          ).toList());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddItems()));
          },
        ),
      ),
    );
  }
}
