import 'set.dart';
import '../dxf.dart';

/// HEADER Section
///
/// The HEADER section in a DXF file records the drawing's variable settings.
/// Each variable is represented by a 9 group code specifying its name,
/// followed by additional groups that define its value.
/// Only variables saved within the drawing file are included in this section.
class HeaderSection extends Section {
  HeaderSection();

  int _nextHandle = 400;
  String increase() {
    String curr = _nextHandle.toRadixString(16);
    _nextHandle++;
    Code.search(codes, 5).value = _nextHandle.toRadixString(16);
    return curr;
  }

  Bounds getBounds() {
    int min = codes.indexWhere(
        (element) => element.code == 9 && element.value == '\$EXTMIN');
    int max = codes.indexWhere(
        (element) => element.code == 9 && element.value == '\$EXTMAX');
    Bounds b = Bounds.from(
        codes[min + 1].value,
        codes[min + 2].value,
        codes[min + 3].value,
        codes[max + 1].value,
        codes[max + 2].value,
        codes[max + 3].value);
    return b;
  }

  void setBounds(Bounds bounds) {
    int min = codes.indexWhere(
        (element) => element.code == 9 && element.value == '\$EXTMIN');
    int max = codes.indexWhere(
        (element) => element.code == 9 && element.value == '\$EXTMAX');
    codes[min + 1].value = bounds.min.x;
    codes[min + 2].value = bounds.min.y;
    codes[min + 3].value = bounds.min.z;
    codes[max + 1].value = bounds.max.x;
    codes[max + 2].value = bounds.max.y;
    codes[max + 3].value = bounds.max.z;
  }

  factory HeaderSection.from(List<Code> codes) {
    var section = HeaderSection();
    section.from(codes);
    section._parse();
    return section;
  }

  void _parse() {
    try {
      final result = Code.search(codes, 5);
      _nextHandle = int.parse(result.value, radix: 16);
    } catch (e) {
      _nextHandle = 400;
    }
  }
}
