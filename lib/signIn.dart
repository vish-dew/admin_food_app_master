import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'Uni',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                          children: <TextSpan>[
                        TextSpan(
                            text: 'Foodie',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 35))
                      ])),
                  Text(
                    'Admin Panel',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            color: Colors.white70,
                            // fontWeight: FontWeight.bold,
                            letterSpacing: 2.0),
                        labelStyle: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Colors.white70,
                            // fontWeight: FontWeight.w700,
                            letterSpacing: 2.0),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      child
                          // child: isLoading
                          // ? Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       CircularProgressIndicator(
                          //         backgroundColor: Colors.deepPurple,
                          //       ),
                          //       const SizedBox(
                          //         width: 15,
                          //       ),
                          //       Text(
                          //         'Please wait...',
                          //         style: TextStyle(color: Colors.deepPurple),
                          //       ),
                          //     ],
                          //   )
                          : Text(
                        "LOG IN",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      onPressed: () {
                        final String email = emailController.text.trim();
                        final String password = passwordController.text.trim();

                        if (email.isEmpty) {
                          print("Email id Empty");
                        } else {
                          if (password.isEmpty) {
                            print("Password is empty");
                          } else {
                            context.read<AuthService>().login(email, password);
                          }
                        }
                        // if (isLoading) return;
                        // setState(() => isLoading = true);
                        // await Future.delayed(Duration(seconds: 3));
                        // setState(() => isLoading = false);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),

                    // ignore: deprecated_member_use
                    child: FlatButton(
                      child: Text("SIGN UP",
                          style: TextStyle(color: Colors.deepPurple)),
                      onPressed: () {
                        final String email = emailController.text.trim();
                        final String password = passwordController.text.trim();

                        if (email.isEmpty) {
                          print("Email id Empty");
                        } else {
                          if (password.isEmpty) {
                            print("Password is empty");
                          } else {
                            try {
                              context
                                  .read<AuthService>()
                                  .signUp(email, password)
                                  .then((value) async {
                                User? user = FirebaseAuth.instance.currentUser;
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user!.uid)
                                    .set({
                                  'uid': user.uid,
                                  'email': email,
                                  'password': password,
                                  'createAt': DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString(),
                                });
                              });
                            } catch (e) {
                              print("LoginError:($e)");
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
