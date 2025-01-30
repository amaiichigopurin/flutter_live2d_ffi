#import "FlutterLive2dFFIPlugin.h"

@implementation FlutterLive2dFFIPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_live2d_ffi"
            binaryMessenger:[registrar messenger]];
  FlutterLive2dFFIPlugin* instance = [[FlutterLive2dFFIPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  // Live2DPlatformViewFactory 등록 (Flutter에서 사용할 수 있도록)
   FlutterPlatformViewFactory *factory = [[Live2DPlatformViewFactory alloc] init];
    [registrar registerViewFactory:factory withId:@"live2d_view"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
