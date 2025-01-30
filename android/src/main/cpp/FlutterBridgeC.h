/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

 /* 
    기존 SDK 샘플의 JniBridgeC를 Flutter용으로 수정한 버전
    ✅ FFI로 호출할 함수들을 extern "C"로 감싸서 이름 맹글링 방지
    ✅ Flutter에서 DynamicLibrary.lookupFunction()으로 이 함수들을 호출 가능

    .hpp => .h로 변경
 */

// #pragma once
// #include <Type/csmVector.hpp>
// #include <Type/csmString.hpp>

#ifdef __cplusplus
extern "C" {
#endif

void nativeOnStart();
void nativeOnPause();
void nativeOnStop();
void nativeOnDestroy();
void nativeOnSurfaceCreated();
void nativeOnSurfaceChanged(int width, int height);
void nativeOnDrawFrame();
void nativeOnTouchesBegan(float pointX, float pointY);
void nativeOnTouchesEnded(float pointX, float pointY);
void nativeOnTouchesMoved(float pointX, float pointY);

#ifdef __cplusplus
}
#endif

/**
* @brief 기존 Jni Bridge Class
*/
// class FlutterBridgeC
// {
// public:
//     /**
//     * @brief Assets 取得 (필요 없음! Flutter에서 Dart 코드로 대체 가능.)
//     */
//     //static Csm::csmVector<Csm::csmString> GetAssetList(const Csm::csmString& path);
//     /*
//     JNI를 통해 Java의 context.getAssets().list(path)를 호출하여 앱 내 에셋 파일 목록을 가져옴.
//     Android에서만 동작하는 코드 (iOS와 다르게 NSBundle을 사용하지 않음).
//     Flutter에서는 Dart의 AssetManifest.json을 이용해 에셋 리스트를 가져올 수 있음.

//     Flutter에서 대체 방법
//     import 'package:flutter/services.dart';
//     import 'dart:convert';

//     Future<List<String>> getAssetList() async {
//     final manifestContent = await rootBundle.loadString('AssetManifest.json');
//     final Map<String, dynamic> manifestMap = json.decode(manifestContent);
//         return manifestMap.keys.toList();
//     }
//     */

//     /**
//     * @brief Javaからファイル読み込み (필요 없음)
//     */
//     //static char* LoadFileAsBytesFromJava(const char* filePath, unsigned int* outSize);
//     /*
//     JNI를 사용하여 Java의 context.getAssets().open(filePath)를 통해 파일을 바이트 배열로 읽음.
//     Android의 AssetManager에서만 동작하는 코드.
//     iOS에서는 NSBundle.mainBundle().path(forResource: "file", ofType: "ext") 사용.
//     Flutter에서는 rootBundle.load()를 사용하여 에셋을 읽을 수 있음.

//     Flutter에서 대체 방법
//     import 'package:flutter/services.dart';

//     Future<ByteData> loadFileAsBytes(String path) async {
//         return await rootBundle.load(path);
//     }
//     */

//     /**
//     * @brief アプリをバックグラウンドに移動 (Flutter에서는 필요 없음)
//     */
//     //static void MoveTaskToBack();
//     /*
//     JNI를 통해 Java의 activityInstance.moveTaskToBack(true);를 호출하여 앱을 백그라운드로 이동.
//     Android에서만 동작하며, iOS에서는 사용할 수 없음.
//     Flutter에서는 SystemNavigator.pop()이나 moveTaskToBack 플러그인을 사용하면 됨.

//     Flutter에서 대체 방법
//     import 'package:flutter/services.dart';

//     void moveAppToBackground() {
//         SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//     }
//     */

// };



