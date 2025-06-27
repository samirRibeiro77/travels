import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Travel {
  late String _title;
  late LatLng _coordinates;

  Travel(this._title, this._coordinates);

  Travel.fromJson(Map<String, dynamic> json) {
    _title = json["title"];

    GeoPoint geoPoint = json["coordinate"];
    _coordinates = LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": _title,
      "coordinates": GeoPoint(_coordinates.latitude, _coordinates.longitude),
    };
  }
}
