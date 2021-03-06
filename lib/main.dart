import 'package:corrona_frontend/page/countries.dart';
import 'package:corrona_frontend/page/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      
      home: new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new Home(),
        image: new Image.asset('assets/icon.png'),
        backgroundColor: Color.fromRGBO(33, 37, 41, 100),
        // styleTextUnderTheLoader: new TextStyle(),
        photoSize: 40.0,
        loaderColor: Colors.red
      ),
    );
    
  }

  
}

