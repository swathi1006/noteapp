import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:noteapp/model/note.dart';
import 'package:noteapp/screens/splashpage.dart';

void main() async {
  await Hive.initFlutter();
  /// register adapter to perform crud operation
  Hive.registerAdapter(NoteAdapter());
  ///open Hive box to perform crud operation
  await Hive.openBox<Note>('my_notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}