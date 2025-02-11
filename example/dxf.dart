import 'package:dxf_viewer/dxf_viewer.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Widget> initDxf() async {
    DXF d = await DXF.create();
    DxfText text = DxfText(d, x: 50, y: 10, z: 0, textString: 'Text to set');
    d.addEntity(text);
    DxfLine line = DxfLine(d, x: 50, y: 10, x1: 100, y1: 10);
    d.addEntity(line);
    DxfImage di = DxfImage(d, const Size(2, 2));
    return DxfViewer(dxf: di);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('My Home Page'),
          ),
          body: FutureBuilder<Widget>(
              future: initDxf(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(child: snapshot.data);
                } else {
                  return const CircularProgressIndicator();
                }
              })),
    );
  }
}
