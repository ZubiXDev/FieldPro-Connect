// ignore_for_file: file_names

import 'package:attendence/Admin/AddEmployee.dart';
import 'package:attendence/Admin/AdminLogin.dart';
import 'package:attendence/Admin/EmployeeProfile.dart';
import 'package:attendence/Admin/InAppChat/ChatHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'LocationOnMap.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool _dataadded = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth auth = FirebaseAuth.instance;

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
              .snapshots(),
          builder: (contexts, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (_dataadded) {
              print('Data');
            }
            if (!snapshots.hasData) {
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 30,
                  color: Colors.blueGrey,
                ),
              );
            }
            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'Welcome Admin',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
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

              drawer: Drawer(
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
                        Icons.person_add,
                        color: Colors.blueGrey,
                      ),
                      title: const Text('Add Employee Account'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEmployee(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.message,
                        color: Colors.blueGrey,
                      ),
                      title: const Text('Messages'),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        // MaterialPageRoute(
                        //     builder: (context) =>
                        //     chatpage(
                        //         email: snapshots.data!.docs.singleWhere(
                        //             (element) =>
                        //                 element.id ==
                        //                 auth.currentUser!
                        //                     .uid)['Employee Name'])));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChatHome(auth.currentUser!.uid)));
                      },
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

              body: SafeArea(
                child: Container(
                  color: Colors.white,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Employees IDs')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      if (snapshot != null && snapshot.data != null) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data!.docs[index]['Role'] ==
                                'Employee') {
                              return Card(
                                elevation: 6,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 02),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                            snapshot.data!
                                                .docs[index]['Attendence Time']
                                                .toDate()
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54)),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EmployeeProfile(
                                                          snapshot.data!
                                                              .docs[index].id,
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                              .id)));
                                        },
                                        title: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                ['Employee Name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.blueGrey),
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Lat: ${snapshot.data!.docs[index]['latitude'].toString()}'),
                                            Text(
                                                'Long: ${snapshot.data!.docs[index]["longitude"].toString()}'),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.directions_sharp,
                                            color: Colors.blueGrey,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            if (snapshot.data!.docs[index]
                                                        ['latitude'] !=
                                                    '' &&
                                                snapshot.data!.docs[index]
                                                        ['longitude'] !=
                                                    '') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MyMap(snapshot
                                                              .data!
                                                              .docs[index]
                                                              .id)));
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
                                                      "Employee Location Doesn't Added Yet"),
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  width: 320.0,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          18, 4, 4, 4),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        leading: CircleAvatar(
                                          child: ClipOval(
                                            child: snapshot.data!.docs[index]
                                                        ['Profile Pic'] ==
                                                    ''
                                                ? const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )
                                                // Image.asset('assets/userpic.png')
                                                : Image.network(
                                                    snapshot.data!.docs[index]
                                                        ['Profile Pic'],
                                                    fit: BoxFit.cover,
                                                    width: 300,
                                                    height: 150,
                                                  ),
                                          ),

                                          // foregroundImage:
                                          //     AssetImage('assets/userpic.png'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container(
                              color: Colors.amber,
                            );
                          },
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
                ),
              ),

              // body: SafeArea(
              //   child: Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Text(
              //           'WELCOME',
              //           style: TextStyle(
              //               fontSize: 52,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.blueGrey),
              //         ),
              //         const Text(
              //           'ADMIN',
              //           style: TextStyle(
              //               fontSize: 40,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.blueGrey),
              //         ),
              //         const SizedBox(
              //           height: 40,
              //         ),
              //         SizedBox(
              //           height: 50,
              //           width: 290,
              //           child: ElevatedButton(
              //             style: ButtonStyle(
              //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //                 RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(20.0),
              //                 ),
              //               ),
              //             ),
              //             onPressed: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => const AddEmployee(),
              //                 ),
              //               );
              //             },
              //             child: const Text(
              //               'Create A New Employee ID',
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ),
              //         ),
              //         const SizedBox(
              //           height: 18,
              //         ),
              //         SizedBox(
              //           height: 50,
              //           width: 290,
              //           child: ElevatedButton(
              //             style: ButtonStyle(
              //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //                 RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(20.0),
              //                 ),
              //               ),
              //             ),
              //             onPressed: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => const CheckEmployeeLocation(),
              //                 ),
              //               );
              //             },
              //             child: const Text(
              //               'Check Employee Location',
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            );
          }),
    );
  }

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AdminLogin()));
  }
}
