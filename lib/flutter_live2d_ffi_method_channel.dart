import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_live2d_ffi_platform_interface.dart';

/// An implementation of [FlutterLive2dFFIPlatform] that uses method channels.
class MethodChannelFlutterLive2dFFI extends FlutterLive2dFFIPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_live2d_ffi');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
