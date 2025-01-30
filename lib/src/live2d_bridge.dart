import 'dart:ffi';
import 'dart:io';

abstract class Live2D {
  static final DynamicLibrary _live2dLib = _resolveNativeLib();

  static DynamicLibrary _resolveNativeLib() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open("libLive2DCubismCore.so"); // Android 동적 라이브러리
    } else if (Platform.isIOS) {
      // return DynamicLibrary.open("libLive2DCubismCore.a"); // iOS 동적 라이브러리 사용 불가
      return DynamicLibrary.process(); // iOS 정적 라이브러리
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  // C++ 네이티브 함수 정의 (Dart → C++)
  static final void Function() nativeOnStart = _live2dLib.lookupFunction<Void Function(), void Function()>("nativeOnStart");

  static final void Function() nativeOnPause = _live2dLib.lookupFunction<Void Function(), void Function()>("nativeOnPause");

  static final void Function() nativeOnStop = _live2dLib.lookupFunction<Void Function(), void Function()>("nativeOnStop");

  static final void Function() nativeOnDestroy = _live2dLib.lookupFunction<Void Function(), void Function()>("nativeOnDestroy");

  static final void Function() nativeOnSurfaceCreated = _live2dLib.lookupFunction<Void Function(), void Function()>("nativeOnSurfaceCreated");

  static final void Function(int, int) nativeOnSurfaceChanged =
      _live2dLib.lookupFunction<Void Function(Int32, Int32), void Function(int, int)>("nativeOnSurfaceChanged");

  static final void Function() nativeOnDrawFrame = _live2dLib.lookupFunction<Void Function(), void Function()>("nativeOnDrawFrame");

  static final void Function(double, double) nativeOnTouchesBegan =
      _live2dLib.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesBegan");

  static final void Function(double, double) nativeOnTouchesEnded =
      _live2dLib.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesEnded");

  static final void Function(double, double) nativeOnTouchesMoved =
      _live2dLib.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesMoved");
}
