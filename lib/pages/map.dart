import 'package:air_quality_app/models/api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import '../data/api_service.dart';
import '../data/popup_info.dart';
import '../models/route_model.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import '../widgets/popup.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _Map();
}

class _Map extends State<Map> {
  final MapController mapController = MapController();

  Position? _currentPosition;
  String? _currentAddress;

  ApiModel? _apiModel;

  // Demo - Bangkok, Thailand
  // late LatLng center = LatLng(31.3407, 121.5074);

  List<LatLng> pointList = [];
  final List<LatLng> _markerPositions = [
    LatLng(13.7470, 100.4856),
    LatLng(13.7481, 100.4895),
    LatLng(13.7446, 100.4848),
    LatLng(13.7419, 100.4901),
    LatLng(13.7410, 100.4875),
    LatLng(13.7416, 100.4836),
    LatLng(13.7393, 100.4815),
    LatLng(13.7262, 100.4807),
    LatLng(13.7502, 100.4805),
  ];
  var model = RoutesModel();

  // Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => _getCurrentLocation());
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => _updatePointsList());
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            forceAndroidLocationManager: true,
            desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      print(_currentPosition);

      _getAddressFromLatLng();
    }).catchError((e) {
      throw Exception(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  List<LatLng> _updatePointsList() {
    pointList
        .add(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    return pointList;
  }

  List<Marker> _updateMarkersList() {
    List<Marker> markers = [];

    markers.add(Marker(
        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        builder: (BuildContext context) {
          return IconButton(
            onPressed: () {},
            icon: const Icon(Icons.circle),
            iconSize: 20.0,
            color: Colors.blueAccent,
          );
        }));

    return markers;
  }

  List<Marker> get _popupMarkers {
    return _markerPositions
        .map(
          (markerPosition) => Marker(
            point: markerPosition,
            width: 20,
            height: 20,
            builder: (_) {
              _getAqiData(markerPosition);
              int api = _apiModel!.list[0].main.aqi;
              Color color = getPopupInfo(api).color;
              return Icon(Icons.location_on, size: 30, color: color);
            },
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        )
        .toList();
  }

  // fetch data from API
  _getAqiData(LatLng position) async {
    _apiModel = (await ApiService().getAPIData(
        position.latitude.toString(), position.longitude.toString()))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  _insertRoute() async {
    await model.insertRoute(pointList);
  }

  _loadRoute() async {
    model.getAllRoutes();
  }

  @override
  Widget build(BuildContext context) {
    _checkPermissions();
    return Scaffold(
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            zoom: 16.0,
            center: pointList.last,
            onTap: (_) => _popupLayerController
                .hideAllPopups(), // Hide popup when the map is tapped.
          ),
          children: <Widget>[
            TileLayerWidget(
              options: TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/kellypham0109/ckwqyk94h2d1f15phs6e4ms0j/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VsbHlwaGFtMDEwOSIsImEiOiJja3dxeWY3NngwcGozMnZwNGw3dGo4eWJ6In0.4n5CN9cyR4H7fLMpnxU6Qw",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1Ijoia2VsbHlwaGFtMDEwOSIsImEiOiJja3dxeWY3NngwcGozMnZwNGw3dGo4eWJ6In0.4n5CN9cyR4H7fLMpnxU6Qw',
                    'id': 'mapbox.mapbox-streets-v8'
                  }),
            ),
            MarkerLayerWidget(
                options: MarkerLayerOptions(markers: _updateMarkersList())),
            PolylineLayerWidget(
              options: PolylineLayerOptions(polylines: [
                Polyline(
                    color: Colors.blueAccent,
                    strokeWidth: 2.0,
                    points: _updatePointsList()),
              ]),
            ),
            PopupMarkerLayerWidget(
              options: PopupMarkerLayerOptions(
                  popupController: _popupLayerController,
                  markers: _popupMarkers,
                  markerRotateAlignment:
                      PopupMarkerLayerOptions.rotationAlignmentFor(
                          AnchorAlign.top),
                  popupBuilder: (BuildContext context, Marker marker) {
                    _getAqiData(
                        LatLng(marker.point.latitude, marker.point.longitude));
                    int aqi = _apiModel!.list[0].main.aqi;
                    return PopupWidget(marker, aqi);
                  }),
            ),
            // OverlayImageLayerOptions()
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                child: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  _getCurrentLocation();
                  _insertRoute();
                }),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
                child: const Icon(
                  Icons.upload,
                  color: Colors.white,
                ),
                onPressed: () {
                  _getCurrentLocation();
                  _loadRoute();
                }),
          ],
        ));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<Position> _checkPermissions() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    Geolocator.requestPermission();

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
