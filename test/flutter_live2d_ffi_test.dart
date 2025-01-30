import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi_platform_interface.dart';
import 'package:flutter_live2d_ffi/flutter_live2d_ffi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLive2dFFIPlatform with MockPlatformInterfaceMixin implements FlutterLive2dFFIPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLive2dFFIPlatform initialPlatform = FlutterLive2dFFIPlatform.instance;

  test('$MethodChannelFlutterLive2dFFI is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLive2dFFI>());
  });

  test('getPlatformVersion', () async {
    FlutterLive2dFFI flutterLive2dFFIPlugin = FlutterLive2dFFI();
    MockFlutterLive2dFFIPlatform fakePlatform = MockFlutterLive2dFFIPlatform();
    FlutterLive2dFFIPlatform.instance = fakePlatform;

    expect(await flutterLive2dFFIPlugin.getPlatformVersion(), '42');
  });
}
