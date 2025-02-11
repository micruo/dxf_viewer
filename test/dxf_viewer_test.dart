import 'dart:io';

import 'package:dxf_viewer/dxf_viewer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('verifica', () async {
    var d = await DXF.create();
    d.save(File('prova2.dxf'));
  });

}
