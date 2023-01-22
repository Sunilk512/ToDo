import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_list_with_firebase/signupage.dart';

import 'firebase_helper.dart';
import 'homepage.dart';
//ignore_for_file: prefer_const_constructors

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    isLoading = true;
    _notify();

    final failOrSuccess = await FirebaseHelper.login(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim());
    isLoading = false;
    _notify();
    if (failOrSuccess == null) {
      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      return;
    }

    Fluttertoast.showToast(msg: failOrSuccess);
  }

  void _notify() {
    if (mounted) {
      setState(() {});
    }
  }

  final _forkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _forkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 100,
                      width: 180,
                      child: Center(
                          child: Text(
                        "Log In Here",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedErrorBorder:OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      
                    ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                      labelText: "Enter Email",
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: "Enter Your Email",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedErrorBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                      labelText: "Enter Password",
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: "Enter Your Password",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal),
                                ),
                                onPressed: () {
                                  if (_forkey.currentState!.validate()) {
                                    login();
                                  }
                                },
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text(
                          "Don't Have Account ?",
                          style:
                              TextStyle(color: Colors.white, fontSize: 15),
                        )),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
