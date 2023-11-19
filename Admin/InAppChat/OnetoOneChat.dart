// ignore_for_file: file_names, must_be_immutable, unnecessary_null_comparison, avoid_print, await_only_futures

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class OnetoOneChat extends StatefulWidget {
  String cuidt;
  String groupChatId;
  OnetoOneChat({required this.cuidt, required this.groupChatId, super.key});

  @override
  State<OnetoOneChat> createState() => _OnetoOneChatState();
}

class _OnetoOneChatState extends State<OnetoOneChat> {
  String? mtoken = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    getToken();
    initInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object>>(
      stream:
          FirebaseFirestore.instance.collection('Employees IDs').snapshots(),
      builder: (context,
          // AsyncSnapshot
          AsyncSnapshot<QuerySnapshot<Object>> snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshots != null && snapshots.data != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshots.data?.docs.singleWhere(
                  (element) => element.id == widget.cuidt)['Employee Name']),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .doc(widget.groupChatId)
                        .collection(widget.groupChatId)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot != null && snapshot.data != null) {
                        return ListView.builder(
                          controller: listScrollController,
                          reverse: true,
                          itemCount: snapshot.data?.docs.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, bottom: 5, top: 5),
                              child: Column(
                                crossAxisAlignment: user!.uid ==
                                        snapshot.data!.docs[index]['idFrom']
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Container(
                                      margin: user!.uid ==
                                              snapshot.data!.docs[index]
                                                  ['idFrom']
                                          ? const EdgeInsets.only(left: 40)
                                          : const EdgeInsets.only(right: 40),
                                      child: ListTile(
                                        tileColor: (user!.uid ==
                                                snapshot.data!.docs[index]
                                                    ['idFrom']
                                            ? Colors.blueGrey.shade500
                                            : Colors.blueGrey.shade100),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                ['content'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: (user!.uid ==
                                                      snapshot.data!.docs[index]
                                                          ['idFrom']
                                                  ? Colors.white
                                                  : Colors.black),
                                            ),
                                          ),
                                        ),
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
                        color: Colors.lime,
                      );
                    },
                  ),
                ),
                const Divider(
                  height: 1.0,
                ),
                Align(
                  // alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, bottom: 10, top: 10, right: 3),
                    height: 60,
                    width: double.infinity,
                    // color: Colors.blueGrey.shade400,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _textController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blueGrey.shade50,
                              hintText: "Write message...",
                              hintStyle: const TextStyle(color: Colors.black54),
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
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            onSendMessage(
                                snapshots.data!.docs.singleWhere((element) =>
                                    element.id == widget.cuidt)['token'],
                                _textController.text,
                                snapshots.data!.docs.singleWhere((element) =>
                                    element.id == user!.uid)['Employee Name']);
                            _textController.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          color: Colors.tealAccent,
        );
      },
    );
  }

  onSendMessage(
    String token,
    String content,
    String title,
  ) {
    if (content.isNotEmpty) {
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.groupChatId)
          .collection(widget.groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': user!.uid,
            'idTo': widget.cuidt,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            textColor: Colors.white,
            label: 'OK',
            onPressed: () {},
          ),
          content: const Text("Nothing To Send."),
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
    sendPushMessage(token, content, title);
  }

  void requestNotificationPermission() async {
    final messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User Granted Provisional Permission');
    } else {
      print('User Declained Permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        mtoken = value;
        print('My Token IS $mtoken');
      });
      saveToken(value!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('Employees IDs')
        .doc(user!.uid)
        .set({"token": token}, SetOptions(merge: true));
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // print("Notification Message is ${payload.input}");
        // print("Notification Message is ${payload.toString()}");
        // print("Notification actionid is ${payload.actionId.toString()}");
        // print("Notification id is ${payload.id.toString()}");
        // print("Notification payload is ${payload.payload.toString()}");
        // print(
        //     "Notification id is ${payload.notificationResponseType.toString()}");
        try {
          if (payload != null && payload != '') {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => NewScreen(
            //               info: payload.toString(),
            //             )));
          } else {}
        } catch (e) {}
        return;
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('......................ONMessagae......................');
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails("dbfood", "dbfood",
              importance: Importance.max,
              styleInformation: bigTextStyleInformation,
              priority: Priority.max,
              playSound: false);
      NotificationDetails platformChannelSpecific =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecific,
          payload: message.data['body']);
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': "application/json",
          'Authorization':
              'key=AAAAGsvG9Vw:APA91bFUr1WJWb648B9nf46Tz4ottgs47jPrPffXOMFX60miZuoYIM0Aj0mZmhpox4A3QHzNlgCM5ElFQOuF2gbsMJamnaXw3Tk4-ZyPzpdFYYYy-32I4nTd2nYxQT9ReeI8wRL450Bj'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'android_channel_id': 'dbfood'
            },
            'to': token
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }
}
