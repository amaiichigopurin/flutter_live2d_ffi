import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi_platform_interface.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLive2dFfiPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLive2dFfiPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLive2dFfiPlatform initialPlatform = FlutterLive2dFfiPlatform.instance;

  test('$MethodChannelFlutterLive2dFfi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLive2dFfi>());
  });

  test('getPlatformVersion', () async {
    FlutterLive2dFfi flutterLive2dFfiPlugin = FlutterLive2dFfi();
    MockFlutterLive2dFfiPlatform fakePlatform = MockFlutterLive2dFfiPlatform();
    FlutterLive2dFfiPlatform.instance = fakePlatform;

    expect(await flutterLive2dFfiPlugin.getPlatformVersion(), '42');
  });
}
