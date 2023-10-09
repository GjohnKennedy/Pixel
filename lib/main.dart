import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pixel/ImageModel.dart';

import 'HomeScreen.dart';

void main() async {
  /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.white, // status bar color
  ));*/
  await Hive.initFlutter();
  Hive.registerAdapter(ImageModelAdapter());
  Hive.registerAdapter(CropDetailsAdapter());
  Hive.registerAdapter(ViewCustomAdapter());
  await Hive.openBox('images');
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
