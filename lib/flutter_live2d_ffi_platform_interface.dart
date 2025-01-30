import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_live2d_ffi_method_channel.dart';

abstract class FlutterLive2dFfiPlatform extends PlatformInterface {
  /// Constructs a FlutterLive2dFfiPlatform.
  FlutterLive2dFfiPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLive2dFfiPlatform _instance = MethodChannelFlutterLive2dFfi();

  /// The default instance of [FlutterLive2dFfiPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLive2dFfi].
  static FlutterLive2dFfiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLive2dFfiPlatform] when
  /// they register themselves.
  static set instance(FlutterLive2dFfiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
