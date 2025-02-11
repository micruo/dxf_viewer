import 'package:flutter/material.dart';
import 'xyz.dart';
import '../sections/blocks.dart';
import '../dxf.dart';

class DxfMText extends DxfXyz {
  String _textString = '';
  double _textHeight = 3;
  double _columnWidth = 20;

  String get textString => _textString;
  set textString(String value) {
    setCode(1, value);
    _textString = value;
  }

  double get textHeight => _textHeight;
  set textHeight(double value) {
    setCode(40, value);
    _textHeight = value;
  }

  double get columnWidth => _columnWidth;
  set columnWidth(double value) {
    setCode(41, value);
    _columnWidth = value;
  }

  DxfMText.init(super.codes) : super.init();

  factory DxfMText.from(List<Code> codes) {
    var entity = DxfMText.init(codes);
    entity.setCodes(codes);
    entity._textString = entity.getCode(1);
    entity._textHeight = entity.getCode(40);
    entity._columnWidth = entity.getCode(41);
    return entity;
  }

  DxfMText(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
    String textString = '',
    double textHeight = 3,
    double columnWidth = 20.0,
  })  : _textString = textString,
        _textHeight = textHeight,
        _columnWidth = columnWidth,
        super(dxf, 'MTEXT', layerName, 'AcDbMText', x, y, z, [
          Code(40, textHeight),
          Code(41, columnWidth),
          Code(46, 0.0),
          Code(71, 1),
          Code(72, 5),
          Code(1, '{\\fArial|b0|i0|c163|p34;$textString}'),
          Code(73, 1),
          Code(44, 1.0),
          Code(1001, 'ACAD')
        ]);
  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) {
    canvas.save();
    canvas.scale(1, -1);
    final TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: _textString,
            style: TextStyle(
              color: Colors.black,
              fontSize: _textHeight * 1.5,
            )),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr)
      ..layout();
    textPainter.paint(canvas, Offset(x, -(y + _textHeight)));
    canvas.restore();
  }
}
