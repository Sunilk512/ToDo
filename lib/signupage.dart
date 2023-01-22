import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_list_with_firebase/firebase_helper.dart';
import 'package:to_do_list_with_firebase/homepage.dart';
import 'package:to_do_list_with_firebase/loginpage.dart';
//ignore_for_file: prefer_const_constructors

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
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
                  Container(
                    height: 100,
                    width: 400,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Create an Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        labelText: 'Enter Email',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(color: Colors.white)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Email';
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.15),
                        border: InputBorder.none,
                        labelText: 'Enter Password',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "Enter your Password",
                        hintStyle: TextStyle(color: Colors.white)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
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
                                if (isLoading) return;
                                if (_forkey.currentState!.validate()) {
                                  createAccount();
                                }
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Already An Account ?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
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

  Future<void> createAccount() async {
    isLoading = true;
    _notify();

    final failOrSuccess = await FirebaseHelper.createAccount(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim());
    isLoading = false;
    _notify();
    if (failOrSuccess == null) {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
      return;
    }

    Fluttertoast.showToast(msg: failOrSuccess);
  }

  void _notify() {
    if (mounted) {
      setState(() {});
    }
  }
}
