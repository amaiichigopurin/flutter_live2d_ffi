import 'flutter_live2d_ffi_platform_interface.dart';

class FlutterLive2dFFI {
  Future<String?> getPlatformVersion() {
    return FlutterLive2dFFIPlatform.instance.getPlatformVersion();
  }
}
