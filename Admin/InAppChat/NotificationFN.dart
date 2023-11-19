// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;

// class NotificationFN {
//   String? mtoken = '';
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void requestPermission() async {
//     final messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true);
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User Granted Permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User Granted Provisional Permission');
//     } else {
//       print('User Declained Permission');
//     }
//   }

//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((value) {
//       setState(() {
//         mtoken = value;
//         print('My Token IS $mtoken');
//       });
//       saveToken(value!);
//     });
//   }

//   void saveToken(String token) async {
//     await FirebaseFirestore.instance
//         .collection('UserTokens')
//         .doc("User1")
//         .set({"token": token});
//   }

//   initInfo() {
//     var androidInitialize =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: androidInitialize);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (payload) {
//         // print("Notification Message is ${payload.input}");
//         // print("Notification Message is ${payload.toString()}");
//         // print("Notification actionid is ${payload.actionId.toString()}");
//         // print("Notification id is ${payload.id.toString()}");
//         // print("Notification payload is ${payload.payload.toString()}");
//         // print(
//         //     "Notification id is ${payload.notificationResponseType.toString()}");
//         try {
//           if (payload != null && payload != '') {
//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (context) => NewScreen(
//             //               info: payload.toString(),
//             //             )));
//           } else {}
//         } catch (e) {}
//         return;
//       },
//     );
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print('......................ONMessagae......................');
//       print(
//           'onMessage: ${message.notification?.title}/${message.notification?.body}');
//       BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//           message.notification!.body.toString(),
//           htmlFormatBigText: true,
//           contentTitle: message.notification!.title.toString(),
//           htmlFormatContentTitle: true);

//       AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails("dbfood", "dbfood",
//               importance: Importance.max,
//               styleInformation: bigTextStyleInformation,
//               priority: Priority.max,
//               playSound: false);
//       NotificationDetails platformChannelSpecific =
//           NotificationDetails(android: androidPlatformChannelSpecifics);
//       await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
//           message.notification?.body, platformChannelSpecific,
//           payload: message.data['body']);
//     });
//   }

//   void sendPushMessage(String token, String body, String title) async {
//     try {
//       await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': "application/json",
//           'Authorization':
//               'key=AAAACHqEW7Q:APA91bG9ZqaXGwU2I0wGkx1lqufrs78In03mVQwUSCQ-U3Dr3sqDtneD6PVTBucsalvYsn3VR_30vnkFBoRWCuUGvJnmxerk8P3MZpea319Cq89z5IhNHhrMeOrHTpy6sLMcBh-N9AyD'
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'status': 'done',
//               'body': body,
//               'title': title
//             },
//             'notification': <String, dynamic>{
//               'body': body,
//               'title': title,
//               'android_channel_id': 'dbfood'
//             },
//             'to': token
//           },
//         ),
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print('error push notification');
//       }
//     }
//   }
// }
