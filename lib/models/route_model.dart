import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../data/route.dart';

class RoutesModel {
  final CollectionReference _routeCollection =
      FirebaseFirestore.instance.collection('routes');

  Future<void> getAllRoutes() async {
    _routeCollection
        .get()
        .then((value) {})
        .catchError((error) => throw Exception(error));
  }

  Future<void> insertRoute(List<LatLng> route) async {
    List<GeoPoint> list = [];
    for (LatLng point in route) {
      list.add(GeoPoint(point.latitude, point.longitude));
    }

    return _routeCollection
        .add({'name': list})
        .then((value) {})
        .catchError((error) => throw Exception(error));
  }

  Future<void> updateRoute(Route route) async {
    return _routeCollection
        .doc(route.id.toString())
        .update(route.toMap())
        .then((value) {})
        .catchError((error) => throw Exception(error));
  }

  Future<void> deleteRoute(Route route) async {
    return _routeCollection
        .doc(route.id.toString())
        .delete()
        .then((value) {})
        .catchError((error) => throw Exception(error));
  }
}
