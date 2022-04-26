import 'package:latlong2/latlong.dart';

class Route {
  String id;
  List<LatLng> name;

  Route(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  Route.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        name = map['name'] as List<LatLng>;

  @override
  String toString() {
    return 'Grade{id: $id name: $name}';
  }
}
