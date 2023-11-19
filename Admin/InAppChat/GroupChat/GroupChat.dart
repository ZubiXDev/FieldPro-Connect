// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  TextEditingController message = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MMB Technology'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Employees IDs')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
              return Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Group Messages')
                          .orderBy('time')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("something is wrong");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot != null && snapshot.data != null) {
                          return ListView.builder(
                            itemCount: snapshot.data?.docs.length ?? 0,
                            // physics: const ScrollPhysics(),
                            // shrinkWrap: true,
                            // primary: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                // padding: const EdgeInsets.only(top: 8, bottom: 8),
                                child: Column(
                                  crossAxisAlignment: snapshots.data?.docs
                                              .singleWhere((element) =>
                                                  element.id ==
                                                  auth.currentUser!
                                                      .uid)['Employee Name'] ==
                                          snapshot.data!.docs[index]['email']
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: ListTile(
                                        tileColor: (snapshots.data?.docs
                                                        .singleWhere((element) =>
                                                            element.id ==
                                                            auth.currentUser!
                                                                .uid)[
                                                    'Employee Name'] ==
                                                snapshot.data!.docs[index]
                                                    ['email']
                                            ? Colors.blueGrey.shade600
                                            : Colors.blueGrey.shade100),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Text(
                                          snapshot.data!.docs[index]['email'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: (snapshots.data?.docs
                                                            .singleWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    auth.currentUser!
                                                                        .uid)[
                                                        'Employee Name'] ==
                                                    snapshot.data!.docs[index]
                                                        ['email']
                                                ? Colors.white
                                                : Colors.black),
                                          ),
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['message'],
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: (snapshots.data?.docs.singleWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      auth.currentUser!
                                                                          .uid)[
                                                              'Employee Name'] ==
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['email']
                                                      ? Colors.white
                                                      : Colors.black),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${snapshot.data!.docs[index]['time'].toDate().hour}:${snapshot.data!.docs[index]['time'].toDate().minute}",
                                              style: TextStyle(
                                                color: (snapshots.data?.docs
                                                                .singleWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        auth.currentUser!
                                                                            .uid)[
                                                            'Employee Name'] ==
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['email']
                                                    ? Colors.white
                                                    : Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Container(
                          color: Colors.greenAccent,
                        );
                      },
                    ),
                  ),
                  // GroupMessages(
                  //     email: snapshot.data?.docs.singleWhere((element) =>
                  //         element.id ==
                  //         auth.currentUser!.uid)['Employee Name']),
                  const Divider(
                    height: 1.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, bottom: 10, top: 10, right: 3),
                      height: 60,
                      width: double.infinity,
                      color: Colors.blueGrey.shade400,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: message,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blueGrey.shade50,
                                hintText: "Write message...",
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              if (message.text.isNotEmpty) {
                                FirebaseFirestore.instance
                                    .collection('Group Messages')
                                    .doc()
                                    .set({
                                  'message': message.text,
                                  'time': DateTime.now(),
                                  'email': snapshots.data?.docs.singleWhere(
                                      (element) =>
                                          element.id ==
                                          auth.currentUser!
                                              .uid)['Employee Name'],
                                });

                                message.clear();
                              }
                            },
                            backgroundColor: Colors.white,
                            // elevation: 0,
                            child: const Icon(
                              Icons.send,
                              color: Colors.blueGrey,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
