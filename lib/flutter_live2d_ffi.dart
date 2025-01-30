import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';

export 'live2d_view.dart';

/*
안드로이드 (FFI)	
  FFI 사용 (네이티브 C++ .so 직접 호출)
  DynamicLibrary.open("libLive2DCubismCore.so")	
  live2d_bridge.dart에서 바로 C++ 함수 호출	FlutterBridgeC.m을 통해 C++ 코드 호출

iOS (MethodChannel)
	Flutter MethodChannel 사용 (Objective-C Wrapper 필요)
  FlutterMethodChannel 사용
  Jni 필요 없음	MethodChannel을 통해 Flutter 연결
*/

/// Live2D에서는 Flutter에서 네이티브 함수를 호출하는 "단방향" 흐름만 필요함으로 MethodChannel이 필요 없다.
/// [수정] 하지만 iOS는 FlutterBridgeC.m을 통해 C++ 코드 호출을 해야 하기 때문에 MethodChannel을 사용해야 한다...
class FlutterLive2DFFI {
  static const MethodChannel _iosMethodChannel = MethodChannel('flutter_live2d_ffi');

  static final DynamicLibrary? _androidLive2DLib = Platform.isAndroid ? DynamicLibrary.open("libLive2DCubismCore.so") : null;

  // FFI (Android) 네이티브 함수 로드
  static final void Function()? _nativeOnStart = _androidLive2DLib?.lookupFunction<Void Function(), void Function()>("nativeOnStart");
  static final void Function()? _nativeOnPause = _androidLive2DLib?.lookupFunction<Void Function(), void Function()>("nativeOnPause");
  static final void Function()? _nativeOnStop = _androidLive2DLib?.lookupFunction<Void Function(), void Function()>("nativeOnStop");
  static final void Function()? _nativeOnDestroy = _androidLive2DLib?.lookupFunction<Void Function(), void Function()>("nativeOnDestroy");
  static final void Function()? _nativeOnSurfaceCreated = _androidLive2DLib?.lookupFunction<Void Function(), void Function()>("nativeOnSurfaceCreated");
  static final void Function(int, int)? _nativeOnSurfaceChanged =
      _androidLive2DLib?.lookupFunction<Void Function(Int32, Int32), void Function(int, int)>("nativeOnSurfaceChanged");
  static final void Function()? _nativeOnDrawFrame = _androidLive2DLib?.lookupFunction<Void Function(), void Function()>("nativeOnDrawFrame");
  static final void Function(double, double)? _nativeOnTouchesBegan =
      _androidLive2DLib?.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesBegan");
  static final void Function(double, double)? _nativeOnTouchesEnded =
      _androidLive2DLib?.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesEnded");
  static final void Function(double, double)? _nativeOnTouchesMoved =
      _androidLive2DLib?.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesMoved");

  // 네이티브 함수 호출 (Android: FFI, iOS: MethodChannel)
  static Future<void> nativeOnStart() async {
    if (Platform.isAndroid) {
      _nativeOnStart?.call();
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnStart');
    }
  }

  static Future<void> nativeOnPause() async {
    if (Platform.isAndroid) {
      _nativeOnPause?.call();
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnPause');
    }
  }

  static Future<void> nativeOnStop() async {
    if (Platform.isAndroid) {
      _nativeOnStop?.call();
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnStop');
    }
  }

  static Future<void> nativeOnDestroy() async {
    if (Platform.isAndroid) {
      _nativeOnDestroy?.call();
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnDestroy');
    }
  }

  static Future<void> nativeOnSurfaceCreated() async {
    if (Platform.isAndroid) {
      _nativeOnSurfaceCreated?.call();
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnSurfaceCreated');
    }
  }

  static Future<void> nativeOnSurfaceChanged(int width, int height) async {
    if (Platform.isAndroid) {
      _nativeOnSurfaceChanged?.call(width, height);
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnSurfaceChanged', {'width': width, 'height': height});
    }
  }

  static Future<void> nativeOnDrawFrame() async {
    if (Platform.isAndroid) {
      _nativeOnDrawFrame?.call();
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnDrawFrame');
    }
  }

  static Future<void> nativeOnTouchesBegan(double x, double y) async {
    if (Platform.isAndroid) {
      _nativeOnTouchesBegan?.call(x, y);
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnTouchesBegan', {'x': x, 'y': y});
    }
  }

  static Future<void> nativeOnTouchesMoved(double x, double y) async {
    if (Platform.isAndroid) {
      _nativeOnTouchesMoved?.call(x, y);
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnTouchesMoved', {'x': x, 'y': y});
    }
  }

  static Future<void> nativeOnTouchesEnded(double x, double y) async {
    if (Platform.isAndroid) {
      _nativeOnTouchesEnded?.call(x, y);
    } else if (Platform.isIOS) {
      await _iosMethodChannel.invokeMethod('nativeOnTouchesEnded', {'x': x, 'y': y});
    }
  }
}
