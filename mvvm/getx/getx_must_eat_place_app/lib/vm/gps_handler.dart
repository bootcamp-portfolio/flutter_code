import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class GpsHandler extends GetxController {
  //위도경도만
  var latitude = ''.obs;
  var longitude = ''.obs;
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
      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();
    }
  }
}
