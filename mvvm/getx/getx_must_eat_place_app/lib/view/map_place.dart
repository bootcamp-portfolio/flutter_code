import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:latlong2/latlong.dart';

class MapPlace extends StatelessWidget {
  const MapPlace({super.key}); //생성자 말고 get arguments

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? "__";
    final double lat = args[0];
    final double lng = args[1];

    return Scaffold(
      appBar: AppBar(title: Text("위치 보기")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.tj.musteatapp',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80,
                  height: 80,
                  point: LatLng(lat, lng),
                  child: Icon(
                    Icons.pin_drop,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
