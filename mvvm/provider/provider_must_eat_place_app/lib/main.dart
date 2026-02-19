import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_must_eat_place_app/view/query_place.dart';
import 'package:provider_must_eat_place_app/vm/gps_handler.dart';
import 'package:provider_must_eat_place_app/vm/image_handler.dart';
import 'package:provider_must_eat_place_app/vm/vm_handler.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ImageModel(),
        ),

        ChangeNotifierProvider(
          create: (context) =>
              GpsModel()..checkLocationPermission(),
        ),

        ChangeNotifierProvider(
          create: (context) => VMModel()..loadAddress(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const QueryPlace(),
    );
  }
}
