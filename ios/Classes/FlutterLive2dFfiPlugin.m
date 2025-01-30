#import "FlutterLive2DFFIPlugin.h"
#import "LAppDelegate.hpp"

@implementation FlutterLive2DFFIPlugin
 
 + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_live2d_ffi"
                                                                binaryMessenger:[registrar messenger]];
    FlutterLive2DFFIPlugin* instance = [[FlutterLive2DFFIPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

      // Live2DPlatformViewFactory 등록 (Flutter에서 사용할 수 있도록)
   FlutterPlatformViewFactory *factory = [[Live2DPlatformViewFactory alloc] init];
    [registrar registerViewFactory:factory withId:@"live2d_view"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"nativeOnStart"]) {
        LAppDelegate::GetInstance()->OnStart();
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnPause"]) {
        LAppDelegate::GetInstance()->OnPause();
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnStop"]) {
        LAppDelegate::GetInstance()->OnStop();
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnDestroy"]) {
        LAppDelegate::GetInstance()->OnDestroy();
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnSurfaceCreated"]) {
        LAppDelegate::GetInstance()->OnSurfaceCreate();
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnSurfaceChanged"]) {
        NSDictionary *args = call.arguments;
        int width = [args[@"width"] intValue];
        int height = [args[@"height"] intValue];
        LAppDelegate::GetInstance()->OnSurfaceChanged(width, height);
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnDrawFrame"]) {
        LAppDelegate::GetInstance()->Run();
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnTouchesBegan"]) {
        NSDictionary *args = call.arguments;
        float x = [args[@"x"] floatValue];
        float y = [args[@"y"] floatValue];
        LAppDelegate::GetInstance()->OnTouchBegan(x, y);
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnTouchesMoved"]) {
        NSDictionary *args = call.arguments;
        float x = [args[@"x"] floatValue];
        float y = [args[@"y"] floatValue];
        LAppDelegate::GetInstance()->OnTouchMoved(x, y);
        result(nil);
    } else if ([call.method isEqualToString:@"nativeOnTouchesEnded"]) {
        NSDictionary *args = call.arguments;
        float x = [args[@"x"] floatValue];
        float y = [args[@"y"] floatValue];
        LAppDelegate::GetInstance()->OnTouchEnded(x, y);
        result(nil);
    } else if ([call.method isEqualToString:@"getAssetPath"]) {
        NSString* assetPath = call.arguments[@"asset"];
        NSString* fullPath = [[NSBundle mainBundle] pathForResource:assetPath ofType:nil];
        result(fullPath);
    } else if ([call.method isEqualToString:@"loadModel"]) {
        // NSDictionary *args = call.arguments;
        // NSString* modelPath = args[@"path"];
        // LAppDelegate::GetInstance()->LoadModel(modelPath);     

        NSDictionary *args = call.arguments;
        NSString* modelPath = args[@"path"];

        if (modelPath == nil) {
            result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                       message:@"Model path is null"
                                       details:nil]);
            return;
        }

        // // NSString -> std::string 변환 (C++ 함수 호출을 위해)
        // std::string modelPathStr = std::string([modelPath UTF8String]);
        // LAppDelegate::GetInstance()->LoadModel(modelPathStr);
        
        // LAppLive2DManager에서 모델 로드
        [[LAppLive2DManager getInstance] loadModel:modelPath];

        result(nil);   
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
