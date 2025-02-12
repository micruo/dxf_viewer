import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../model/dxf_entity.dart';

import '../dxf.dart';

/// A Widget to show a DXF
class DxfViewer extends StatelessWidget {
  final DXF _dxf;
  final double _width;
  final double _height;
  final Size scale;

  /// Create a new DxfViewer loading from a file
  DxfViewer.fromFile(File file,
      {super.key,
      double width = 100,
      double height = 100,
      this.scale = const Size(1, 1)})
      : _width = width * scale.width.abs(),
        _height = height * scale.height.abs(),
        _dxf = DXF.fromFile(file);

  /// Create a new DxfViewer from a DXF
  DxfViewer(this._dxf,
      {super.key,
      double width = 100,
      double height = 100,
      this.scale = const Size(1, 1)})
      : _width = width * scale.width.abs(),
        _height = height * scale.height.abs();

  void _paint(Canvas canvas, Size size) {
    Bounds bounds = _dxf.bounds;
    double iScale = min(size.width / (bounds.max.x - bounds.min.x + 10),
        size.height / (bounds.max.y - bounds.min.y + 10));
    var paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 0.5 / iScale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;
    canvas.scale(iScale * scale.width, -iScale * scale.height);
    canvas.translate(scale.width < 0 ? -bounds.max.x - 5 : -bounds.min.x + 5,
        scale.height < 0 ? -bounds.min.y + 5 : -bounds.max.y - 5);
    for (DxfEntity e in _dxf.entities) {
      e.draw(_dxf.blocks, canvas, paint);
    }
  }

  /// retrieve an image as ByteData
  Future<ByteData?> imageData(
      {int width = 100, int height = 100, bool applyScale = false}) async {
    ui.PictureRecorder r = ui.PictureRecorder();
    Canvas c = Canvas(r);
    _paint(
        c,
        Size(width / (applyScale ? scale.width : 1.0),
            height / (applyScale ? scale.height : 1.0)));
    var picture = r.endRecording();
    var a = await picture.toImage(width, height);
    return a.toByteData(format: ui.ImageByteFormat.png);
  }

  /// retrieve an image as Image
  Future<Image> image({int width = 100, int height = 100}) async {
    var p = await imageData(width: width, height: height, applyScale: true);
    return Image.memory(p!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        height: _height,
        child: CustomPaint(
          painter: _DxfPainter(this),
          child: Container(),
        ));
  }
}

class _DxfPainter extends CustomPainter {
  final DxfViewer _dxf;
  _DxfPainter(this._dxf);

  @override
  void paint(Canvas canvas, Size size) {
    _dxf._paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
