import 'dart:async';

import 'package:fieldpro/Employee/EmployeeLogin.dart';
import 'package:fieldpro/Employee/ShowAssignLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class EmployeePanel extends StatefulWidget {
  var locationSubscription;
  EmployeePanel({required this.locationSubscription, super.key});

  @override
  State<EmployeePanel> createState() => _EmployeePanelState();
}

class _EmployeePanelState extends State<EmployeePanel> {
 
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Location location = Location();
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;


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
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Employees IDs')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 30,
                color: Colors.blueGrey,
              ),
            );
          }
          // ignore: unnecessary_null_comparison
          if (snapshot != null && snapshot.data != null) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu_open,
                    size: 34,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    if (scaffoldKey.currentState!.isDrawerOpen) {
                      scaffoldKey.currentState!.closeDrawer();
                    } else {
                      scaffoldKey.currentState!.openDrawer();
                    }
                  },
                ),
              ),
              drawer: 
             Drawer(
                      width: MediaQuery.of(context).size.width - 80,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          SizedBox(
                            height: 160,
                            child: DrawerHeader(
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'MMB',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  ),
                                  Text(
                                    'Technologies',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListTile(
                           
                            leading: const Icon(
                              Icons.message,
                              color: Colors.blueGrey,
                            ),
                            title: const Text('Messages'),
                          ),
                          const ListTile(
                            leading: Icon(
                              Icons.account_circle,
                              color: Colors.blueGrey,
                            ),
                            title: Text('Profile'),
                          ),
                          const ListTile(
                            leading: Icon(
                              Icons.settings,
                              color: Colors.blueGrey,
                            ),
                            title: Text('Settings'),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.logout_outlined,
                              color: Colors.blueGrey,
                            ),
                            title: const Text('Logout'),
                            onTap: () {
                              signOut();
                            
                            },
                          ),
                        ],
                      ),
                    ),
                
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),

                      const Text(
                        'WELCOME',
                        style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      const Text(
                        'EMPLOYEE',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),

                      const SizedBox(
                        height: 80,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        color: Colors.white,
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          elevation: 6,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text("Date And Time :",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black54)),
                              ),
                              Text(
                                  snapshot.data!['Assign Location Time']
                                      .toDate()
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(8, 4, 8, 8),
                                title: const Padding(
                                  padding: EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    'Assign Location',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!['Assign Latitude']
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                    ),
                                    Text(
                                        snapshot.data!['Assign Longitude']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54)),
                                  ],
                                ),
                                leading: const Icon(
                                  Icons.share_location_rounded,
                                  color: Colors.blueGrey,
                                  size: 38,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    if (snapshot.data!['Assign Latitude'] !=
                                            '' &&
                                        snapshot.data!['Assign Longitude'] !=
                                            '') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowAssignLocation(
                                                      snapshot.data!.id)));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          action: SnackBarAction(
                                            textColor: Colors.white,
                                            label: 'OK',
                                            onPressed: () {},
                                          ),
                                          content: const Text(
                                              "Admin Doesn't Assign You Any Location Yet"),
                                          duration: const Duration(seconds: 3),
                                          width: 330.0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.directions_rounded,
                                    color: Colors.blueGrey,
                                    size: 38,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container(
            color: Colors.blue,
            child: const Center(
              child: Text('container'),
            ),
          );
        },
      ),
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

  stopListening() {
    widget.locationSubscription?.cancel();
    setState(() {
      widget.locationSubscription = null;
    });
  }

  signOut() async {
    await auth.signOut();

    setState(() {
      stopListening();
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const EmployeeLogin()));
  }
}
