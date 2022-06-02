import 'package:flutter/services.dart';
import 'homepage.dart';
import 'package:flutter/material.dart';


//Mostly the default main.dart file
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //attempts to force app into portrait orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Pong',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //Sets the homepage for the app (where most stuff happens)
      home: const HomePage(),
    );
  }
}



