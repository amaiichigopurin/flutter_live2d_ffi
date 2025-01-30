
import 'flutter_live2d_ffi_platform_interface.dart';

class FlutterLive2dFfi {
  Future<String?> getPlatformVersion() {
    return FlutterLive2dFfiPlatform.instance.getPlatformVersion();
  }
}
