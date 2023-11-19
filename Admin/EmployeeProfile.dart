import 'package:fieldpro/Admin/AdminPanel.dart';
import 'package:fieldpro/Admin/AssignLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeProfile extends StatefulWidget {
  final String user_id;
  final String testid;
  const EmployeeProfile(this.user_id, this.testid, {super.key});

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  bool _dataadded = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('Employees IDs').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (_dataadded) {
          print('Data');
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 30,
              color: Colors.blueGrey,
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 34,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminPanel()));
              },
            ),
            title: Text(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['Role'],
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height - 170,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Column(
                      children: [
                        Card(
                          elevation: 4,
                          child: SizedBox(
                            height: 160,
                            child: Center(
                              child: CircleAvatar(
                                radius: 63,
                                backgroundColor: Colors.blueGrey,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.blueGrey,
                                  child: ClipOval(
                                    child: snapshot.data!.docs.singleWhere(
                                                    (element) =>
                                                        element.id ==
                                                        widget.user_id)[
                                                'Profile Pic'] ==
                                            ''
                                        ? const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 90,
                                          )
                                        : Image.network(
                                            snapshot.data!.docs.singleWhere(
                                                    (element) =>
                                                        element.id ==
                                                        widget.user_id)[
                                                'Profile Pic'],
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
                        const SizedBox(
                          height: 2,
                        ),
                        Card(
                          elevation: 4,
                          child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Employee Name :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        snapshot.data!.docs.singleWhere(
                                            (element) =>
                                                element.id ==
                                                widget
                                                    .user_id)['Employee Name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Employee ID :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        snapshot.data!.docs.singleWhere(
                                            (element) =>
                                                element.id ==
                                                widget.user_id)['Employee ID'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Role :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 106,
                                      ),
                                      Text(
                                        snapshot.data!.docs.singleWhere(
                                            (element) =>
                                                element.id ==
                                                widget.user_id)['Role'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Card(
                          elevation: 4,
                          child: SizedBox(
                            height: 120,
                            width: MediaQuery.of(context).size.width - 16,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Current Location Coordinates :",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    snapshot.data!.docs.singleWhere((element) =>
                                            element.id ==
                                            widget.user_id)['latitude'] +
                                        ' , ' +
                                        snapshot.data!.docs.singleWhere(
                                            (element) =>
                                                element.id ==
                                                widget.user_id)['longitude'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blueGrey),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    "Attendence Time :",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    snapshot.data!.docs
                                        .singleWhere((element) =>
                                            element.id ==
                                            widget.user_id)['Attendence Time']
                                        .toDate()
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Card(
                          elevation: 4,
                          child: SizedBox(
                            height: 150,
                            width: MediaQuery.of(context).size.width - 16,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Assign Location Coordinates :",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        snapshot.data!.docs
                                            .singleWhere((element) =>
                                                element.id ==
                                                widget
                                                    .user_id)['Assign Latitude']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                      ),
                                      Text(
                                        snapshot.data!.docs
                                            .singleWhere(
                                                (element) =>
                                                    element.id ==
                                                    widget.user_id)[
                                                'Assign Longitude']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    "Assign Location Time :",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    snapshot.data!.docs
                                        .singleWhere(
                                            (element) =>
                                                element.id == widget.user_id)[
                                            'Assign Location Time']
                                        .toDate()
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 290,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AssignLocation(
                                    snapshot.data!.docs
                                        .singleWhere((element) =>
                                            element.id == widget.testid)
                                        .id,
                                  )));
                    },
                    child: const Text(
                      'Assign Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
