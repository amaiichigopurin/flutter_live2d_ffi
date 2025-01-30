import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_live2d_ffi_method_channel.dart';

abstract class FlutterLive2dFFIPlatform extends PlatformInterface {
  /// Constructs a FlutterLive2dFFIPlatform.
  FlutterLive2dFFIPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLive2dFFIPlatform _instance = MethodChannelFlutterLive2dFFI();

  /// The default instance of [FlutterLive2dFFIPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLive2dFFI].
  static FlutterLive2dFFIPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLive2dFFIPlatform] when
  /// they register themselves.
  static set instance(FlutterLive2dFFIPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
