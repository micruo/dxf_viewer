import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'model/dxf_entity.dart';
import 'model/dxf_block.dart';
import 'model/dxf_insert.dart';
import 'sections/blocks.dart';
import 'sections/header.dart';
import 'sections/classes.dart';
import 'sections/tables.dart';
import 'sections/entities.dart';
import 'sections/objects.dart';

/// Drawing Exchange Format (DXF)
///
/// The DXF™ file format represents the contents of an AutoCAD® drawing file as a structured, tagged data format.
class DXF {
  /// DXF codes
  final _codes = <Code>[];

  late HeaderSection _headerSection;
  ClassesSection? _classesSection;
  late TablesSection _tablesSection;
  late BlocksSection _blocksSection;
  late EntitiesSection _entitiesSection;
  ObjectsSection? _objectsSection;

  /// Get all entities
  List<DxfEntity> get entities => _entitiesSection.entities;

  /// Get the BLOCKS section
  BlocksSection get blocks => _blocksSection;
  Bounds get bounds => _headerSection.getBounds();
  String newHandle() => _headerSection.increase();

  /// Add an entity to the DXF object
  void addEntity(DxfEntity entity) {
    _entitiesSection.addEntity(entity);
    _recalcBoundaries();
  }

  void _recalcBoundaries() {
    Bounds bounds = Bounds();
    for (var element in _entitiesSection.entities) {
      element.calcBoundaries(_blocksSection, bounds, Offset.zero);
    }
    _headerSection.setBounds(bounds);
  }

  /// Get entity by handle
  DxfEntity? getEntityByHandle(String handle) {
    return _entitiesSection.getEntityByHandle(handle);
  }

  /// Remove entity
  bool removeEntity(DxfEntity entity) {
    if (!_entitiesSection.removeEntity(entity)) return false;
    _recalcBoundaries();
    return true;
  }

  /// Create a new DXF object
  static Future<DXF> create() async {
    var dxf =
        DXF(await rootBundle.loadString('packages/dxf_viewer/assets/init.dxf'));
    return dxf;
  }

  /// Create a DXF object reading it from a String
  DXF(String dxfString) {
    var lines = const LineSplitter().convert(dxfString);
    int? code;
    int lineNo = 0;
    try {
      for (var line in lines) {
        if (code != null) {
          dynamic value = line;
          if (code >= 10 && code < 60) {
            value = double.parse(line);
          } else if (code >= 60 && code < 80) {
            value = int.parse(line);
          }
          _codes.add(Code(code, value));
          code = null;
        } else {
          code = int.parse(line);
        }
        lineNo++;
      }
    } catch (e) {
      throw FormatException('Invalid group code at line $lineNo');
    }
    var codes = <Code>[];
    for (var el in _codes) {
      if (el.code == 0 && el.value == 'SECTION') {
        codes = [];
        codes.add(el);
      } else if (codes.isNotEmpty) {
        codes.add(el);
        if (el.code == 0 && el.value == 'ENDSEC') {
          var cg = codes[1];
          assert(cg.code == 2);
          switch (cg.value.toString()) {
            case 'BLOCKS':
              _blocksSection = BlocksSection.from(codes);
            case 'CLASSES':
              _classesSection = ClassesSection.from(codes);
            case 'HEADER':
              _headerSection = HeaderSection.from(codes);
            case 'ENTITIES':
              _entitiesSection = EntitiesSection.from(codes);
            case 'OBJECTS':
              _objectsSection = ObjectsSection.from(codes);
            case 'TABLES':
              _tablesSection = TablesSection.from(codes);
          }
        }
      }
    }
  }

  /// Load a DXF ASCII DXF file
  /// A FormatException can be thrown
  factory DXF.fromFile(File f) {
    var dxf = DXF(f.readAsStringSync());
    try {
      dxf._headerSection;
      dxf._tablesSection;
      dxf._blocksSection;
      dxf._entitiesSection;
    } catch (e) {
      throw FormatException('Some section missing in file');
    }
    return dxf;
  }

  void _write(StringSink out) {
    _headerSection.write(out);
    if (_classesSection != null) _classesSection!.write(out);
    _tablesSection.write(out);
    _blocksSection.write(out);
    _entitiesSection.write(out);
    if (_objectsSection != null) _objectsSection!.write(out);
    out.write('  0\r\nEOF\r\n');
  }

  /// Return a string representation of DXF
  String get string {
    StringBuffer sb = StringBuffer();
    _write(sb);
    return sb.toString();
  }

  /// Save DXF to a file
  Future<void> save(File f) async {
    var out = f.openWrite();
    _write(out);
    await out.flush();
    await out.close();
  }

  String modelSpace() =>
      _blocksSection.getBlockByName("*Model_Space").getCode(5);

  /// merge a second DXF into this, as a new BLOCK called [name], at [x],[y],[z] position
  void merge(DXF d, String name, {double x = 0, double y = 0, double z = 0}) {
    String h = newHandle();
    _tablesSection.insertBlock(name, h);
    List<DxfEntity> newEnt = List.from(d.entities.map((e) {
      e.setCode(5, newHandle());
      e.setCode(330, h);
      return e;
    }));
    DxfEntity endBlk =
        DxfEntity(this, 'ENDBLK', '0', [Code(100, 'AcDbBlockEnd')], h);
    newEnt.add(endBlk);
    Block b = Block(this, name: name, entities: newEnt);
    _blocksSection.addBlock(b);
    addEntity(DxfInsert(this, blockName: name, x: x, y: y, z: z));
  }
}

class Code {
  final int code;
  dynamic value;
  Code(this.code, this.value);

  static Code search(List<Code> group, int code) {
    try {
      return group.firstWhere((element) => element.code == code);
    } catch (e) {
      throw FormatException('Missing code $code');
    }
  }

  static Code? trySearch(List<Code> group, int code) =>
      group.where((element) => element.code == code).firstOrNull;

  void write(StringSink s) =>
      s.write('${code.toString().padLeft(3, ' ')}\r\n$value\r\n');
}

class Bounds {
  double minX = 1e30;
  double minY = 1e30;
  double maxX = -1e30;
  double maxY = -1e30;
  Map<String, double> toJson() =>
      {'minX': minX, 'minY': minY, 'maxX': maxX, 'maxY': maxY};
}
