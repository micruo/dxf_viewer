import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../dxf.dart';
import '../model/dxf_entity.dart';

/// Class to convert a dxf in a image
class DxfImage {
  final DXF _dxf;
  final Size scale;
  DxfImage(this._dxf, [this.scale = const Size(1, 1)]);
  DxfImage.fromFile(File f, [this.scale = const Size(1, 1)])
      : _dxf = DXF.fromFile(f);

  void paint(Canvas canvas, Size size) {
    Bounds bounds = _dxf.bounds;
    double iScale = min(size.width / (bounds.max.x - bounds.min.x + 10),
        size.height / (bounds.max.y - bounds.min.y + 10));
    var paint = Paint()
      ..color = Colors.black54
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
  Future<ByteData?> imageData({int width = 100, int height = 100}) async {
    ui.PictureRecorder r = ui.PictureRecorder();
    Canvas c = Canvas(r);
    paint(c, Size(width.toDouble(), height.toDouble()));
    var picture = r.endRecording();
    var a = await picture.toImage(width, height);
    return a.toByteData(format: ui.ImageByteFormat.png);
  }

  /// retrieve an image as Image
  Future<Image> image({int width = 100, int height = 100}) async {
    var p = await imageData(width: width, height: height);
    return Image.memory(p!.buffer.asUint8List());
  }
}
