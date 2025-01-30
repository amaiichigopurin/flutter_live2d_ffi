#import "Live2DPlatformViewFactory.h"
#import "Live2DPlatformView.h"

@implementation Live2DPlatformViewFactory

- (instancetype)init {
    self = [super init];
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                    viewIdentifier:(int64_t)viewId
                                         arguments:(id _Nullable)args
                                   binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    return [[Live2DPlatformView alloc] initWithFrame:frame
                                      viewIdentifier:viewId
                                           arguments:args
                                     binaryMessenger:messenger];
}

@end
