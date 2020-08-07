//import 'dart:async';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:provider/provider.dart';
//import 'package:racingApp/Providers/user.dart';
//import 'package:racingApp/services/geolocator_service.dart';
//
//class FullScreenMap extends StatefulWidget {
//  final Position initialPosition;
//  final String currentUserid;
//
//  FullScreenMap(this.initialPosition,this.currentUserid);
//  @override
//  _FullScreenMapState createState() => _FullScreenMapState();
//}
//
//class _FullScreenMapState extends State<FullScreenMap> {
//  final GeolocatorService geoService = GeolocatorService();
//  Completer<GoogleMapController> _controller = Completer();
//
//  @override
//  void initState() {
//    geoService.getCurrentLocation().listen((position) {
//      Firestore.instance.collection('Users').document(widget.currentUserid).updateData({
//        'lat':position.latitude,
//        'lng':position.longitude
//      });
//      print(position.toString());
//      centerScreen(position);
//    });
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//    double height = MediaQuery.of(context).size.height;
//    double width = MediaQuery.of(context).size.width;
//    return Scaffold(
//        appBar: AppBar(
//          title: Text("LIVE RACERS"),
//          actions: <Widget>[
//            InkWell(
//              onTap: () {},
//              child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Row(
//                    children: <Widget>[
//                      Text(
//                        "Enable ",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                      Icon(
//                        Icons.location_on,
//                        color: Colors.white,
//                        size: 25,
//                      ),
//                    ],
//                  )),
//            )
//          ],
//        ),
//
//        ///body to mark all available racers
//        body: Container(
//          height: height,
//          width: width,
//          child: GoogleMap(
//            initialCameraPosition: CameraPosition(
//                target: LatLng(widget.initialPosition.latitude,
//                    widget.initialPosition.longitude),
//                zoom: 19.151926040649414,bearing: 192.8334901395799,tilt: 59.440717697143555),
//            mapType: MapType.hybrid,
//            myLocationEnabled: true,
//            myLocationButtonEnabled: true,
//
//            onMapCreated: (GoogleMapController controller) {
//              _controller.complete(controller);
//            },
//          )
//        ));
//  }
//
//
//  Future<void> centerScreen(Position position) async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//        target: LatLng(position.latitude, position.longitude), zoom: 19.151926040649414,bearing: 192.8334901395799,tilt: 59.440717697143555)));
//  }
//
//}
