import 'dart:async';
import 'package:flutter/material.dart';
import 'package:starter_template/flavors.dart';

FutureOr<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(),
    );
  }
}
