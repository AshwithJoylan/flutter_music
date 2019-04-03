import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/pages/home/music_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  void initState() { 
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MusicHomePage(),
      ),
    );
  }
}