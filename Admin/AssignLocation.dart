import 'dart:async';

import 'package:fieldpro/Admin/AdminPanel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class AssignLocation extends StatefulWidget {
  final String testuser;
  const AssignLocation(this.testuser, {super.key});

  @override
  State<AssignLocation> createState() => _AssignLocationState();
}

class _AssignLocationState extends State<AssignLocation> {
  final Location location = Location();
  bool _iddataadded = false;

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.5234, 74.3460),
    zoom: 15,
  );

  final List<Marker> _marker = [];
  
  late double asslat;
  late double asslng;

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
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('Employees IDs').snapshots(),
      builder: (
        context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (_iddataadded) {
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
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueGrey,
              onPressed: () async {
          
                print(
                    "${asslat.toString()}+ 'sefsdfds' + ${asslng.toString()}");
                setState(() {
                  assignLocation(snapshot.data!.docs
                      .singleWhere((element) => element.id == widget.testuser)
                      .id);
                  print(widget.testuser);
                });
              },
              child: const Icon(
                Icons.done,
              )),
          body: SafeArea(
            child: GoogleMap(
              zoomControlsEnabled: false,

              onTap: (LatLng latlng) {
                Marker pmarker = Marker(
                  markerId: const MarkerId('Location'),
                  position: LatLng(latlng.latitude, latlng.longitude),
                );

                setState(() {
                  _marker.add(pmarker);
                  asslat = latlng.latitude;
                  asslng = latlng.longitude;
                  
                });
                print('User Pressed At This LatLng: $latlng');
              },
              markers: _marker.map((e) => e).toSet(),
          
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        );
      },
    );
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('Done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  assignLocation(iop) async {
  
    await FirebaseFirestore.instance.collection('Employees IDs').doc(iop).set({
      'Assign Latitude': asslat,
      'Assign Longitude': asslng,
      'Assign Location Time': Timestamp.now(),
    }, SetOptions(merge: true));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AdminPanel()));

  }
}
