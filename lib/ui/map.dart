import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travels/helpers/firebase_helper.dart';
import 'package:travels/helpers/location_helper.dart';
import 'package:travels/model/travel.dart';

class TravelMap extends StatefulWidget {
  const TravelMap({super.key, this.travelId});

  final String? travelId;

  @override
  State<TravelMap> createState() => _TravelMapState();
}

class _TravelMapState extends State<TravelMap> {
  final _db = FirebaseFirestore.instance;
  final _controller = Completer<GoogleMapController>();

  final Set<Marker> _markers = {};

  var _cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10);

  _createLocationListener() async {
    await LocationHelper.isLocationEnabled();

    var settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    Geolocator.getPositionStream(locationSettings: settings).listen((position) {
      _moveCamera(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        )
      );
    });
  }

  _moveCamera(CameraPosition cameraPosition) async {
    var controller = await _controller.future;
    setState(() {
      _cameraPosition = cameraPosition;
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _showMarker(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    var firstPlaceMark = placemarks.first;
    var travel = Travel(
      "${firstPlaceMark.thoroughfare} - ${firstPlaceMark.subThoroughfare}",
      position,
    );

    _createMarker(travel);

    _db.collection(FirebaseHelpers.collections.travels).add(travel.toJson());
  }

  _createMarker(Travel travel) {
    var marker = Marker(
      markerId: MarkerId("travel-${travel.coordinates.latitude}-${travel.coordinates.longitude}"),
      position: travel.coordinates,
      infoWindow: InfoWindow(
        title: travel.title,
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  _getTravelById(String id) async {
    var docSnapshot = await _db.collection(FirebaseHelpers.collections.travels).doc(id).get();
    var travel = Travel.fromMap(docSnapshot.data()!);

    _createMarker(travel);
    _moveCamera(CameraPosition(
      target: LatLng(travel.coordinates.latitude, travel.coordinates.longitude),
      zoom: 17,
    ));
  }

  @override
  void initState() {
    if (widget.travelId == null) {
      _createLocationListener();
    } else {
      _getTravelById(widget.travelId!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        myLocationEnabled: true,
        onLongPress: _showMarker,
      ),
    );
  }
}
