/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

 /* 
    기존 SDK 샘플의 JniBridgeC를 Flutter용으로 수정한 버전
    📌 Live2D 모델 로드 및 OpenGL 렌더링을 담당하는 함수 구현
    📌 JNI 관련 코드 삭제하고 OpenGL + Live2D SDK 코드만 유지
    📌 LAppDelegate를 직접 컨트롤하도록 변경
 */

// #include "FlutterBridgeC.h"
// #include <algorithm>
// #include <jni.h>
// #include "LAppDelegate.hpp"
// #include "LAppPal.hpp"

#include "FlutterBridgeC.h"
#include "LAppDelegate.hpp"
#include <iostream>


extern "C" {

void nativeOnStart() {
    std::cout << "[Live2D] OnStart" << std::endl;
    LAppDelegate::GetInstance()->OnStart();
}

void nativeOnPause() {
    std::cout << "[Live2D] OnPause" << std::endl;
    LAppDelegate::GetInstance()->OnPause();
}

void nativeOnStop() {
    std::cout << "[Live2D] OnStop" << std::endl;
    LAppDelegate::GetInstance()->OnStop();
}

void nativeOnDestroy() {
    std::cout << "[Live2D] OnDestroy" << std::endl;
    LAppDelegate::GetInstance()->OnDestroy();
}

void nativeOnSurfaceCreated() {
    std::cout << "[Live2D] Surface Created" << std::endl;
    LAppDelegate::GetInstance()->OnSurfaceCreate();
}

void nativeOnSurfaceChanged(int width, int height) {
    std::cout << "[Live2D] Surface Changed: " << width << " x " << height << std::endl;
    LAppDelegate::GetInstance()->OnSurfaceChanged(width, height);
}

void nativeOnDrawFrame() {
    LAppDelegate::GetInstance()->Run();
}

void nativeOnTouchesBegan(float pointX, float pointY) {
    std::cout << "[Live2D] Touch Began: (" << pointX << ", " << pointY << ")" << std::endl;
    LAppDelegate::GetInstance()->OnTouchBegan(pointX, pointY);
}

void nativeOnTouchesEnded(float pointX, float pointY) {
    std::cout << "[Live2D] Touch Ended: (" << pointX << ", " << pointY << ")" << std::endl;
    LAppDelegate::GetInstance()->OnTouchEnded(pointX, pointY);
}

void nativeOnTouchesMoved(float pointX, float pointY) {
    std::cout << "[Live2D] Touch Moved: (" << pointX << ", " << pointY << ")" << std::endl;
    LAppDelegate::GetInstance()->OnTouchMoved(pointX, pointY);
}

}


// using namespace Csm;

// static JavaVM* g_JVM; // JavaVM is valid for all threads, so just save it globally
// static jclass  g_JniBridgeJavaClass;
// static jmethodID g_GetAssetsMethodId;
// static jmethodID g_LoadFileMethodId;
// static jmethodID g_MoveTaskToBackMethodId;

// JNIEnv* GetEnv()
// {
//     JNIEnv* env = NULL;
//     g_JVM->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6);
//     return env;
// }

// // The VM calls JNI_OnLoad when the native library is loaded
// jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved)
// {
//     g_JVM = vm;

//     JNIEnv *env;
//     if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) != JNI_OK)
//     {
//         return JNI_ERR;
//     }

//     jclass clazz = env->FindClass("com/live2d/demo/JniBridgeJava");
//     g_JniBridgeJavaClass = reinterpret_cast<jclass>(env->NewGlobalRef(clazz));
//     g_GetAssetsMethodId = env->GetStaticMethodID(g_JniBridgeJavaClass, "GetAssetList", "(Ljava/lang/String;)[Ljava/lang/String;");
//     g_LoadFileMethodId = env->GetStaticMethodID(g_JniBridgeJavaClass, "LoadFile", "(Ljava/lang/String;)[B");
//     g_MoveTaskToBackMethodId = env->GetStaticMethodID(g_JniBridgeJavaClass, "MoveTaskToBack", "()V");

//     return JNI_VERSION_1_6;
// }

// void JNICALL JNI_OnUnload(JavaVM *vm, void *reserved)
// {
//     JNIEnv *env = GetEnv();
//     env->DeleteGlobalRef(g_JniBridgeJavaClass);
// }

// Csm::csmVector<Csm::csmString>JniBridgeC::GetAssetList(const Csm::csmString& path)
// {
//     JNIEnv *env = GetEnv();
//     jobjectArray obj = reinterpret_cast<jobjectArray>(env->CallStaticObjectMethod(g_JniBridgeJavaClass, g_GetAssetsMethodId, env->NewStringUTF(path.GetRawString())));
//     unsigned int size = static_cast<unsigned int>(env->GetArrayLength(obj));
//     Csm::csmVector<Csm::csmString> list(size);
//     for (unsigned int i = 0; i < size; i++)
//     {
//         jstring jstr = reinterpret_cast<jstring>(env->GetObjectArrayElement(obj, i));
//         const char* chars = env->GetStringUTFChars(jstr, nullptr);
//         list.PushBack(Csm::csmString(chars));
//         env->ReleaseStringUTFChars(jstr, chars);
//         env->DeleteLocalRef(jstr);
//     }
//     return list;
// }

// char* JniBridgeC::LoadFileAsBytesFromJava(const char* filePath, unsigned int* outSize)
// {
//     JNIEnv *env = GetEnv();

//     // ファイルロード
//     jbyteArray obj = (jbyteArray)env->CallStaticObjectMethod(g_JniBridgeJavaClass, g_LoadFileMethodId, env->NewStringUTF(filePath));

//     // ファイルが見つからなかったらnullが返ってくるためチェック
//     if (!obj)
//     {
//         return NULL;
//     }

//     *outSize = static_cast<unsigned int>(env->GetArrayLength(obj));

//     char* buffer = new char[*outSize];
//     env->GetByteArrayRegion(obj, 0, *outSize, reinterpret_cast<jbyte *>(buffer));

//     return buffer;
// }

// void JniBridgeC::MoveTaskToBack()
// {
//     JNIEnv *env = GetEnv();

//     // アプリ終了
//     env->CallStaticVoidMethod(g_JniBridgeJavaClass, g_MoveTaskToBackMethodId, NULL);
// }

// extern "C"
// {
//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnStart(JNIEnv *env, jclass type)
//     {
//         LAppDelegate::GetInstance()->OnStart();
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnPause(JNIEnv *env, jclass type)
//     {
//         LAppDelegate::GetInstance()->OnPause();
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnStop(JNIEnv *env, jclass type)
//     {
//         LAppDelegate::GetInstance()->OnStop();
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnDestroy(JNIEnv *env, jclass type)
//     {
//         LAppDelegate::GetInstance()->OnDestroy();
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnSurfaceCreated(JNIEnv *env, jclass type)
//     {
//         LAppDelegate::GetInstance()->OnSurfaceCreate();
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnSurfaceChanged(JNIEnv *env, jclass type, jint width, jint height)
//     {
//         LAppDelegate::GetInstance()->OnSurfaceChanged(width, height);
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnDrawFrame(JNIEnv *env, jclass type)
//     {
//         LAppDelegate::GetInstance()->Run();
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnTouchesBegan(JNIEnv *env, jclass type, jfloat pointX, jfloat pointY)
//     {
//         LAppDelegate::GetInstance()->OnTouchBegan(pointX, pointY);
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnTouchesEnded(JNIEnv *env, jclass type, jfloat pointX, jfloat pointY)
//     {
//         LAppDelegate::GetInstance()->OnTouchEnded(pointX, pointY);
//     }

//     JNIEXPORT void JNICALL
//     Java_com_live2d_demo_JniBridgeJava_nativeOnTouchesMoved(JNIEnv *env, jclass type, jfloat pointX, jfloat pointY)
//     {
//         LAppDelegate::GetInstance()->OnTouchMoved(pointX, pointY);
//     }
// }
