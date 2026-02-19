import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsModel extends ChangeNotifier {
  //위도경도만
  String latitude = '';
  String longitude = '';
  //위 read
  //아래 watch
  Future<void> checkLocationPermission() async {
    LocationPermission permission =
        await Geolocator.checkPermission();
    //사용자의 선택에 따라 달라짐

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever)
      return;

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position =
          await Geolocator.getCurrentPosition();
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      notifyListeners(); //째려본다.
    }
  }
}
