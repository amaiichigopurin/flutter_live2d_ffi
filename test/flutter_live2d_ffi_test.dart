import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi.dart';

void main() {
  test('Live2DView import test', () {
    expect(Live2DView, isNotNull);
  });

  test('FlutterLive2DFFI test', () {
    expect(FlutterLive2DFFI, isNotNull);
  });
}
