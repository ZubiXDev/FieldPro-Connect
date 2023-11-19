import 'dart:async';

import 'package:fieldpro/Admin/AdminPanel.dart';
import 'package:fieldpro/Employee/EmployeeLogin.dart';

import 'package:fieldpro/Widgets/IDField.dart';
import 'package:fieldpro/Widgets/PassField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController aeidcontroller = TextEditingController();
  final TextEditingController aepasscontroller = TextEditingController();

  final Location location = Location();

  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              textColor: Colors.white,
              label: 'OK',
              onPressed: () {},
            ),
            content: const Text("You Can't Go to Previous Screen."),
            duration: const Duration(seconds: 3),
            width: 310.0,
            padding: const EdgeInsets.fromLTRB(18, 4, 8, 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: 40),
                        child: const Center(
                          child: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.blueGrey,
                            size: 150,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                        child: const Text(
                          'Admin Login',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          IdField(
                            idcontroller: aeidcontroller,
                            hinttext: 'Enter Admin ID',
                            inputtype: TextInputType.emailAddress,
                            inputaction: TextInputAction.next,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          PassField(
                            passcontroller: aepasscontroller,
                            hinttext: 'Enter Admin Password',
                            inputtype: TextInputType.text,
                            inputaction: TextInputAction.done,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: 330,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            logindone(
                                aeidcontroller.text, aepasscontroller.text);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Login As Admin !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EmployeeLogin(),
                                ),
                              );
                              setState(() {
                                aeidcontroller.clear();
                                aepasscontroller.clear();
                              });
                            },
                            child: const Text(
                              'Click Here',
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                color: Colors.transparent,
                                decorationThickness: 3,
                                shadows: [
                                  Shadow(
                                    color: Colors.blueGrey,
                                    offset: Offset(0, -5),
                                  )
                                ],
                                decorationColor: Colors.blueGrey,
                              ),
                            ),
                          )
                        ],  
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logindone(String logemail, String logpassword) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: logemail, password: logpassword);
        fromfirebase();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print("No Admin Found For That Email.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'OK',
                onPressed: () {},
              ),
              content: const Text("Invalid Email"),
              duration: const Duration(seconds: 3),
              width: 280.0,
              padding: const EdgeInsets.fromLTRB(18, 4, 8, 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        } else if (e.code == 'Wrong-Password') {
          print("Wrong Password Provided for that Admin.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'OK',
                onPressed: () {},
              ),
              content: const Text("Wrong Password."),
              duration: const Duration(seconds: 3),
              width: 280.0,
              padding: const EdgeInsets.fromLTRB(18, 4, 8, 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        }
      }
    }
  }

  void fromfirebase() {
    User? user = FirebaseAuth.instance.currentUser;
    var ldata = FirebaseFirestore.instance
        .collection('Employees IDs')
        .doc(user!.uid)
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) {
     
        if (documentSnapshot.get('Role') == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminPanel(),
            ),
          );
        } else if (documentSnapshot.get('Role') == 'Employee') {
          print("Admin Doesn't Exist in DataBase");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'OK',
                onPressed: () {},
              ),
              content: const Text("Admin Doesn't Exist."),
              duration: const Duration(seconds: 3),
              width: 310.0,
              padding: const EdgeInsets.fromLTRB(18, 4, 8, 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        }
      },
    );
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
