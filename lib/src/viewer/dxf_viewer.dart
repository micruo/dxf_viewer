import 'dart:io';

import 'package:flutter/material.dart';
import 'dxf_image.dart';

/// A Widget to show a DXF
class DxfViewer extends StatelessWidget {
  final DxfImage _dxfImage;
  final double _width;
  final double _height;
  DxfViewer(
      {super.key,
      File? file,
      DxfImage? dxf,
      double width = 100,
      double height = 100,
      Size scale = const Size(1, 1)})
      : assert(file != null || dxf != null),
        _width = width * scale.width,
        _height = height * scale.height,
        _dxfImage = dxf ?? DxfImage.fromFile(file!, scale);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        height: _height,
        child: CustomPaint(
          painter: _DxfPainter(_dxfImage),
          child: Container(),
        ));
  }
}

class _DxfPainter extends CustomPainter {
  final DxfImage _dxf;
  _DxfPainter(this._dxf);

  @override
  void paint(Canvas canvas, Size size) {
    _dxf.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
