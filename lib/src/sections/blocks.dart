import '../dxf.dart';
import '../model/dxf_block.dart';

/// BLOCKS Section
///
/// The BLOCKS section in a DXF file includes entries that correspond to each block reference used in the drawing.
class BlocksSection {
  BlocksSection();

  /// DXF Group Codes
  final List<Block> _blocks = [];

  factory BlocksSection.from(List<Code> codes) {
    var section = BlocksSection();
    List<Code> nCodes = [];
    for (Code el in codes.skip(2)) {
      if (el.code == 0 &&
          (el.value == 'BLOCK' || el.value == 'ENDSEC') &&
          nCodes.isNotEmpty) {
        Block block = Block.from(nCodes);
        section._blocks.add(block);
        nCodes = [];
      }
      nCodes.add(el);
    }
    return section;
  }
  void addBlock(Block b) => _blocks.add(b);
  Block getBlockByName(String name) =>
      _blocks.firstWhere((element) => element.name == name);
  void write(StringSink s) {
    s.write('  0\r\nSECTION\r\n  2\r\nBLOCKS\r\n');
    for (var g in _blocks) {
      g.write(s);
    }
    s.write('  0\r\nENDSEC\r\n');
  }
}
