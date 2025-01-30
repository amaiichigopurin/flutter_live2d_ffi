import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_live2d_ffi_platform_interface.dart';

/// An implementation of [FlutterLive2dFfiPlatform] that uses method channels.
class MethodChannelFlutterLive2dFfi extends FlutterLive2dFfiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_live2d_ffi');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
