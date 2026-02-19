import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';

class GpsState {
  final String latitude;
  final String longitude;

  GpsState({this.latitude = '', this.longitude = ''});
} //gps

class GpsNotifier extends StateNotifier<GpsState> {
  GpsNotifier() : super(GpsState());

  Future checkLocationPermission() async {
    LocationPermission permission =
        await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever)
      return;

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position =
          await Geolocator.getCurrentPosition();
      state = GpsState(
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
    }
  }
} //notifier

final GpsNotifierProvider =
    StateNotifierProvider<GpsNotifier, GpsState>(
      (ref) => GpsNotifier(),
    );
