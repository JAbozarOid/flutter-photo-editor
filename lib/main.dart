import 'package:flutter/material.dart';
import 'package:photo_editor/profile_picture_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePicturePage(),
    );
  }
}
