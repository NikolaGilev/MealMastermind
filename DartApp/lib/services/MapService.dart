import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapService {
  static final MapService _instance = MapService._privateConstructor();

  MapService._privateConstructor();

  static MapService get instance => _instance;

  Future<void> openMap(double longitude, double latitude) async {
    String startLat = 42.004204515826544.toString();
    String startLon = 21.40954342273825.toString();

    try {
      Position currentLocation = await getCurrentLocation();
      startLon = currentLocation.longitude.toString();
      startLat = currentLocation.latitude.toString();

      String mapUrl = "https://www.google.com/maps/dir/?api=1&origin=${startLat},${startLon}&destination=${latitude
          .toString()},${longitude.toString()}&travelmode=driving";

      await launch(mapUrl);
    } catch(e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white38,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if(permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied!');
    }

    return await Geolocator.getCurrentPosition();
  }
}