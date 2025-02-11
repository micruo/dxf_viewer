import 'dxf_entity.dart';
import 'xyz.dart';
import '../sections/blocks.dart';
import '../dxf.dart';
import '../sections/set.dart';

class Block extends DxfXyz with DxfSet {
  String _name = '';
  int _bType = 0;

  get name => _name;
  get bType => _bType;
  Block.init(super.codes) : super.init();
  factory Block.from(List<Code> codes) {
    Block block = Block.init(codes);
    block.setCodes(codes);
    block._name = block.getCode(2);
    block._bType = block.getCode(70);
    block.addElements(codes, 9);
    return block;
  }
  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Vector off) {
    for (DxfEntity d in entities) {
      d.calcBoundaries(blocks, b, off);
    }
  }

  Block(DXF dxf,
      {required String name,
      int type = 0,
      String layerName = '0',
      required List<DxfEntity> entities})
      : _bType = type,
        _name = name,
        super(
            dxf,
            'BLOCK',
            layerName,
            'AcDbBlockBegin',
            0,
            0,
            0,
            [
              Code(2, name),
              Code(70, type),
              Code(3, name),
            ]
                .followedBy(entities.expand((element) => element.codes))
                .toList()) {
    addEntities(entities);
  }
}
