import 'dart:io';

import 'package:dxf_viewer/dxf_viewer.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DxfViewer? dxf;
  @override
  void initState() {
    DXF d1 = DXF.fromFile(File("test1.dxf"));
    DXF d2 = DXF.fromFile(File("test2.dxf"));
    d1.merge(d2, 'NEW', y: 120.0);
    DxfImage di = DxfImage(d1, const Size(2, 2));
    dxf = DxfViewer(dxf: di);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  dxf ?? const Text('Hello, World!'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
