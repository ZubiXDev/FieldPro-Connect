import 'dart:io';

import 'package:fieldpro/Admin/AdminPanel.dart';
import 'package:fieldpro/Widgets/IDField.dart';
import 'package:fieldpro/Widgets/PassField.dart';
import 'package:fieldpro/Widgets/UserNameField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
 
  TextEditingController nunamecontroller = TextEditingController();
  TextEditingController neidcontroller = TextEditingController();
  TextEditingController nepasscontroller = TextEditingController();

  var options = [
    'Employee',
    'Admin',
  ];

  var _currentItemSelected = "Employee";
  var role = "Employee";


  String profilePicLink = "";

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    Reference ref = FirebaseStorage.instance.ref().child(
        "Employees Pics/${DateTime.now().millisecondsSinceEpoch.toString()}");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 34,
            color: Colors.blueGrey,
          ),
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const AdminPanel()));
          },
        ),
      ),
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            pickUploadProfilePic();
                          },
                          child: CircleAvatar(
                            radius: 63,
                            backgroundColor: Colors.blueGrey,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.blueGrey,
                              child: ClipOval(
                                child: profilePicLink == ''
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 90,
                                      )
                                    : Image.network(
                                        profilePicLink,
                                        fit: BoxFit.cover,
                                        width: 300,
                                        height: 150,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: const Text(
                        'Add New Employee',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    Column(
                      children: [
                        UserNameField(
                            namcontroller: nunamecontroller,
                            hinttext: 'Enter Employee Name',
                            inputtype: TextInputType.name,
                            inputaction: TextInputAction.next),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8)),
                        IdField(
                          idcontroller: neidcontroller,
                          hinttext: 'Enter Employee ID',
                          inputtype: TextInputType.emailAddress,
                          inputaction: TextInputAction.next,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8)),
                        PassField(
                          passcontroller: nepasscontroller,
                          hinttext: 'Enter Employee Password',
                          inputtype: TextInputType.text,
                          inputaction: TextInputAction.done,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Role :   ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          isDense: true,
                          isExpanded: false,
                          iconEnabledColor: Colors.blueGrey,
                          focusColor: Colors.white,
                          items: options.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            setState(() {
                              _currentItemSelected = newValueSelected!;
                              role = newValueSelected;
                            });
                          },
                          value: _currentItemSelected,
                        ),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                          
                          if (profilePicLink.isEmpty) {
                            print('Profile Pic is Required');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                action: SnackBarAction(
                                  textColor: Colors.white,
                                  label: 'OK',
                                  onPressed: () {},
                                ),
                                content: const Text('Profile Pic is Required'),
                                duration: const Duration(seconds: 3),
                                width: 310.0,
                                padding: const EdgeInsets.fromLTRB(18, 4, 8, 4),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          } else if (profilePicLink.isNotEmpty) {
                            doneAdd(
                                profilePicLink.toString(),
                                nunamecontroller.text,
                                neidcontroller.text,
                                nepasscontroller.text,
                                role);
                          }
                        },
                        child: const Text(
                          'ADD : )',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _requestPermission() async {
    var status = await Permission.mediaLibrary.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

    void doneAdd(String pic, String username, String userid, String userpass,
      String role) async {
    const CircularProgressIndicator();

    if (_formkey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: userid, password: userpass)
            .then((value) => sendUserData(
                profilePicLink.toString(),
                nunamecontroller.text,
                neidcontroller.text,
                nepasscontroller.text,
                role));
      } on FirebaseAuthException catch (e) {
        print(e.code);
        print(e.message);
        if (e.code == 'email-already-in-use') {
          print('Email Already is in Use');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'OK',
                onPressed: () {},
              ),
              content: const Text("Email Already Exist."),
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
      }
    }
  
  }

  sendUserData(String pic, String username, String userid, String userpass,
      String role) async {
    var user = _auth.currentUser;
    CollectionReference ref =
        FirebaseFirestore.instance.collection('Employees IDs');
    ref.doc(user!.uid).set({
      'Profile Pic': profilePicLink,
      'Employee Name': username,
      'Employee ID': userid,
      'Password': userpass,
      'Role': role,
      'latitude': '',
      'longitude': '',
      'Assign Latitude': '',
      'Assign Longitude': '',
      'Assign Location Time': Timestamp.now(),
      'Attendence Time': Timestamp.now(),
      'token': ''
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AdminPanel()));
  }
}
