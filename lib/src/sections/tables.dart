import 'package:dxf_viewer/dxf_viewer.dart';

import 'set.dart';
import '../dxf.dart';

/// TABLES Section
///
/// The TABLES section in a DXF™ file consists of multiple tables, each capable of holding a flexible number of entries.
/// The group codes described here are primarily used by applications.
class TablesSection extends Section {
  TablesSection();

  /// Return the Tables section from group codes
  factory TablesSection.from(List<Code> codes) {
    var section = TablesSection();
    section.from(codes);
    return section;
  }

  /// Insert a block inside tables
  void insertBlock(String blockName, String handle) {
    var idx = codes.indexWhere((e) => e.code == 2 && e.value == 'BLOCK_RECORD');
    var el = codes.sublist(idx).where((element) => element.code == 5).first;
    String ref = el.value;
    el = codes.sublist(idx).where((element) => element.code == 70).first;
    el.value = (el.value as int) + 1;
    idx = codes.lastIndexWhere((e) => e.code == 0 && e.value == 'ENDTAB');
    codes.insertAll(idx, [
      Code(0, 'BLOCK_RECORD'),
      Code(5, handle),
      Code(330, ref),
      Code(100, 'AcDbSymbolTableRecord'),
      Code(100, 'AcDbBlockTableRecord'),
      Code(2, blockName),
      Code(340, 0)
    ]);
  }
}
