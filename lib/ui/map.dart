import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travels/helpers/location_helper.dart';

class TravelMap extends StatefulWidget {
  const TravelMap({super.key});

  @override
  State<TravelMap> createState() => _TravelMapState();
}

class _TravelMapState extends State<TravelMap> {
  final _controller = Completer<GoogleMapController>();

  final Set<Marker> _markers = {};

  var _cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10);

  _createLocationListener() {
    var settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    Geolocator.getPositionStream(locationSettings: settings).listen((position) {
      _moveCamera(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        ),
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

    var marker = Marker(
      markerId: MarkerId("travel-${position.latitude}-${position.longitude}"),
      position: position,
      infoWindow: InfoWindow(
        title:
            "${firstPlaceMark.thoroughfare} - ${firstPlaceMark.subThoroughfare}",
        snippet: "Teste"
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  @override
  void initState() {
    _createLocationListener();

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
