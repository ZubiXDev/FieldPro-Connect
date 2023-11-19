// ignore_for_file: file_names

import 'package:attendence/Admin/AdminPanel.dart';
import 'package:attendence/Admin/InAppChat/OnetoOneChat.dart';
import 'package:attendence/Admin/InAppChat/GroupChat/GroupChat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  const ChatHome(String uid, {super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  static final List<Widget> _pages = [
    const ChatTab(),
    const GroupChatTab(),
  ];
  // final bool _dataadded = false;
  final auth = FirebaseAuth.instance;

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return
    //  StreamBuilder(
    //   stream:
    //       FirebaseFirestore.instance.collection('Employees IDs').snapshots(),
    //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return const Text('Something Went Wrong');
    //     }
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CupertinoActivityIndicator(
    //           radius: 30,
    //           color: Colors.blueGrey,
    //         ),
    //       );
    //     }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const AdminPanel()));
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 34,
            color: Colors.blueGrey,
          ),
        ),
        title: const Text(
          'Conversations',
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 34,
              color: Colors.blueGrey,
            ),
          )
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.blueGrey.shade300,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2_sharp),
            label: "Group Chat",
          ),
        ],
      ),
    );
  }
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  String groupChatId = '';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 30,
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 4, 2, 0),
                          filled: true,
                          fillColor: Colors.blueGrey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'e.g:   Zubair Arshad',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Employees IDs')
                            .snapshots(),
                        builder: (context,
                            //  AsyncSnapshot<QuerySnapshot>
                            snapshot) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                color: Colors.white,
                                child: Material(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OnetoOneChat(
                                            cuidt:
                                                snapshot.data!.docs[index].id,
                                            groupChatId: groupChatId,
                                          ),
                                        ),
                                      );
                                      setState(
                                        () {
                                          var currentId =
                                              _auth.currentUser!.uid;
                                          var peerId =
                                              snapshot.data!.docs[index].id;
                                          if (currentId.hashCode <=
                                              peerId.hashCode) {
                                            groupChatId = '$currentId-$peerId';
                                          } else {
                                            groupChatId = '$peerId-$currentId';
                                          }
                                          print(groupChatId);
                                        },
                                      );
                                    },
                                    tileColor: Colors.white,
                                    splashColor: Colors.blueGrey.shade200,
                                    leading: CircleAvatar(
                                      radius: 26,
                                      child: ClipOval(
                                        child: snapshot.data!.docs[index]
                                                    ['Profile Pic'] ==
                                                ''
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 33,
                                              )
                                            : Image.network(
                                                snapshot.data!.docs[index]
                                                    ['Profile Pic'],
                                                fit: BoxFit.cover,
                                                width: 300,
                                                height: 150,
                                              ),
                                      ),
                                    ),
                                    title: Text(
                                      snapshot.data!.docs[index]
                                          ['Employee Name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    subtitle: Text(
                                      snapshot.data!.docs[index]['Role'],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupChatTab extends StatefulWidget {
  const GroupChatTab({super.key});

  @override
  State<GroupChatTab> createState() => _GroupChatTabState();
}

class _GroupChatTabState extends State<GroupChatTab> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          SizedBox(
            height: 60,
            child: Center(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GroupChat(),
                    ),
                  );
                },
                tileColor: Colors.white,
                splashColor: Colors.blueGrey.shade200,
                leading: const CircleAvatar(
                  radius: 26,
                  child: ClipOval(
                    child: Icon(
                      Icons.groups_2,
                      size: 36,
                    ),
                  ),
                ),
                title: const Text(
                  'Group Chat With Employees',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
