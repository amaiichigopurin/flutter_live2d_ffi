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
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
