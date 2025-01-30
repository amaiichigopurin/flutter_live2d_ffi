import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
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

class FlutterLive2DFFI {
  static const MethodChannel _channel = MethodChannel('flutter_live2d_ffi');
  static final DynamicLibrary? _androidLib = Platform.isAndroid ? DynamicLibrary.open("libLive2DCubismCore.so") : null;

  // FFI (Android) 네이티브 함수 로드
  static final void Function()? _nativeOnStart = _androidLib?.lookupFunction<Void Function(), void Function()>("nativeOnStart");
  static final void Function()? _nativeOnPause = _androidLib?.lookupFunction<Void Function(), void Function()>("nativeOnPause");
  static final void Function()? _nativeOnStop = _androidLib?.lookupFunction<Void Function(), void Function()>("nativeOnStop");
  static final void Function()? _nativeOnDestroy = _androidLib?.lookupFunction<Void Function(), void Function()>("nativeOnDestroy");
  static final void Function()? _nativeOnSurfaceCreated = _androidLib?.lookupFunction<Void Function(), void Function()>("nativeOnSurfaceCreated");
  static final void Function(int, int)? _nativeOnSurfaceChanged =
      _androidLib?.lookupFunction<Void Function(Int32, Int32), void Function(int, int)>("nativeOnSurfaceChanged");
  static final void Function()? _nativeOnDrawFrame = _androidLib?.lookupFunction<Void Function(), void Function()>("nativeOnDrawFrame");
  static final void Function(double, double)? _nativeOnTouchesBegan =
      _androidLib?.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesBegan");
  static final void Function(double, double)? _nativeOnTouchesEnded =
      _androidLib?.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesEnded");
  static final void Function(double, double)? _nativeOnTouchesMoved =
      _androidLib?.lookupFunction<Void Function(Float, Float), void Function(double, double)>("nativeOnTouchesMoved");

  // 네이티브 함수 호출 (Android: FFI, iOS: MethodChannel)
  static Future<void> nativeOnStart() async {
    if (Platform.isAndroid) {
      _nativeOnStart?.call();
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnStart');
    }
  }

  static Future<void> nativeOnPause() async {
    if (Platform.isAndroid) {
      _nativeOnPause?.call();
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnPause');
    }
  }

  static Future<void> nativeOnStop() async {
    if (Platform.isAndroid) {
      _nativeOnStop?.call();
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnStop');
    }
  }

  static Future<void> nativeOnDestroy() async {
    if (Platform.isAndroid) {
      _nativeOnDestroy?.call();
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnDestroy');
    }
  }

  static Future<void> nativeOnSurfaceCreated() async {
    if (Platform.isAndroid) {
      _nativeOnSurfaceCreated?.call();
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnSurfaceCreated');
    }
  }

  static Future<void> nativeOnSurfaceChanged(int width, int height) async {
    if (Platform.isAndroid) {
      _nativeOnSurfaceChanged?.call(width, height);
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnSurfaceChanged', {'width': width, 'height': height});
    }
  }

  static Future<void> nativeOnDrawFrame() async {
    if (Platform.isAndroid) {
      _nativeOnDrawFrame?.call();
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnDrawFrame');
    }
  }

  static Future<void> nativeOnTouchesBegan(double x, double y) async {
    if (Platform.isAndroid) {
      _nativeOnTouchesBegan?.call(x, y);
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnTouchesBegan', {'x': x, 'y': y});
    }
  }

  static Future<void> nativeOnTouchesMoved(double x, double y) async {
    if (Platform.isAndroid) {
      _nativeOnTouchesMoved?.call(x, y);
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnTouchesMoved', {'x': x, 'y': y});
    }
  }

  static Future<void> nativeOnTouchesEnded(double x, double y) async {
    if (Platform.isAndroid) {
      _nativeOnTouchesEnded?.call(x, y);
    } else if (Platform.isIOS) {
      await _channel.invokeMethod('nativeOnTouchesEnded', {'x': x, 'y': y});
    }
  }

  static Future<String?> getAssetPath(String assetName) async {
    return await _channel.invokeMethod('getAssetPath', {'asset': assetName});
  }

  static Future<void> loadModel(String assetPath) async {
    if (Platform.isAndroid && nativeLoadModel == null) throw Exception("nativeLoadModel method is not available.");

    // 1. Method Channel을 통해 'getAssetPath' 함수를 호출한다.
    // getAssetPath 함수는 네이티브 쪽 스토리지 내부 'live2d_cache'폴더에 에셋을 복사하고, 해당 경로를 반환한다.
    String? copiedModelNativePath = await getAssetPath(assetPath);
    if (copiedModelNativePath == null) throw Exception("Asset not found: $assetPath");

    // 2. 받은 경로를 네이티브 함수에 전달하기위해 Utf8로 변환한다.
    final pathPointer = copiedModelNativePath.toNativeUtf8();

    try {
      // 3. 네이티브 함수를 호출하여 모델을 로드한다.
      if (Platform.isAndroid) {
        nativeLoadModel!(pathPointer);
      } else if (Platform.isIOS) {
        await _channel.invokeMethod('loadModel', {'path': copiedModelNativePath});
      }
    } finally {
      // 4. 메모리 누수 방지를 위해 메모리 해제
      calloc.free(pathPointer);
    }
  }

  static final void Function(Pointer<Utf8>)? nativeLoadModel =
      _androidLib?.lookupFunction<Void Function(Pointer<Utf8>), void Function(Pointer<Utf8>)>("nativeLoadModel");

  // // Flutter에서는 Dart의 AssetManifest.json을 이용해 에셋 리스트를 가져올 수 있음.
  // static Future<List<String>> getAssetList() async {
  //   final manifestContent = await rootBundle.loadString('AssetManifest.json');
  //   final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  //   return manifestMap.keys.toList();
  // }

  // // JNI를 사용하여 Java의 context.getAssets().open(filePath)를 통해 파일을 바이트 배열로 읽음.
  // // Flutter에서는 rootBundle.load()를 사용하여 에셋을 읽을 수 있음.
  // static Future<ByteData> loadFileAsBytes(String path) async {
  //   return await rootBundle.load(path);
  // }

  // // JNI를 통해 Java의 activityInstance.moveTaskToBack(true);를 호출하여 앱을 백그라운드로 이동.
  // // Flutter에서는 SystemNavigator.pop()이나 moveTaskToBack 플러그인을 사용하면 됨.
  // static void moveAppToBackground() {
  //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  // }
}
