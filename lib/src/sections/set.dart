import 'package:flutter/material.dart';
import '../../dxf_viewer.dart';

/// mixin to create entities from Dxf code
mixin DxfSet {
  /// the entities
  final entities = <DxfEntity>[];
  void addEntities(List<DxfEntity> entities) => this.entities.addAll(entities);
  void addElements(List<Code> gc, int skip) {
    var codes = <Code>[];
    DxfPolyline? pl;
    for (Code el in gc.skip(skip)) {
      if (el.code == 0 && el.value.toString().toUpperCase() == el.value) {
        var nCodes = codes;
        codes = [];
        codes.add(el);
        if (nCodes.isNotEmpty && nCodes.first.code == 0) {
          switch (nCodes.first.value.toString()) {
            case 'ARC':
              entities.add(DxfArc.from(nCodes));
            case 'CIRCLE':
              entities.add(DxfCircle.from(nCodes));
            case 'ELLIPSE':
              entities.add(DxfEllipse.from(nCodes));
            case 'ENDSEQ':
              pl = null;
            case 'INSERT':
              entities.add(DxfInsert.from(nCodes));
            case 'LINE':
              entities.add(DxfLine.from(nCodes));
            case 'LWPOLYLINE':
              entities.add(DxfLwPolyline.from(nCodes));
            case 'MTEXT':
              entities.add(DxfMText.from(nCodes));
            case 'POINT':
              entities.add(DxfPoint.from(nCodes));
            case 'POLYLINE':
              pl = DxfPolyline.from(nCodes);
              entities.add(pl);
            case 'SOLID':
              entities.add(DxfSolid.from(nCodes));
            case 'SPLINE':
              entities.add(DxfSpline.from(nCodes));
            case 'TEXT':
              entities.add(DxfText.from(nCodes));
            case 'VERTEX':
              assert(pl != null);
              pl!.addVertex(nCodes);
            default:
              entities.add(DxfEntity.from(nCodes));
          }
        }
      } else {
        codes.add(el);
      }
    }
  }
}

/// root class for all the Sections
abstract class Section {
  /// DXF Group Codes
  final List<Code> _codes = [];

  @protected
  List<Code> get codes => _codes;

  /// Return the section from group codes
  void from(List<Code> codes) => _codes.addAll(codes);

  /// write this section
  void write(StringSink s) {
    for (var g in _codes) {
      g.write(s);
    }
  }
}
