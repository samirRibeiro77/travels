import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Travel {
  late String _id;
  late String title;
  late LatLng coordinates;

  Travel(this.title, this.coordinates);

  Travel.fromDocumentSnapshot(QueryDocumentSnapshot json) {
    _id = json.id;
    title = json["title"];

    GeoPoint geoPoint = json["coordinates"];
    coordinates = LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  Travel.fromMap(Map<String, dynamic> json, {String id = ""}) {
    _id = id;
    title = json["title"];

    GeoPoint geoPoint = json["coordinates"];
    coordinates = LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "coordinates": GeoPoint(coordinates.latitude, coordinates.longitude),
    };
  }

  String get id => _id;
}
