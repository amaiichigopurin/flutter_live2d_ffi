import 'package:flutter/material.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Live2DView('assets/live2d/haru/haru.model3.json'),
      ),
    );
  }
}
