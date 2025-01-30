#import "Live2DPlatformView.h"

@interface Live2DPlatformView ()
@property (nonatomic, strong) GLKView *glView;
@property (nonatomic, strong) EAGLContext *glContext;
@end

@implementation Live2DPlatformView

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        // OpenGL ES 3.0 컨텍스트 생성
        self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];

        // GLKView 설정
        self.glView = [[GLKView alloc] initWithFrame:frame context:self.glContext];
        self.glView.enableSetNeedsDisplay = YES;
        self.glView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
        self.glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        
        // OpenGL 초기화
        [self setupGL];
    }
    return self;
}

- (UIView*)view {
    return self.glView;
}

- (void)setupGL {
    [EAGLContext setCurrentContext:self.glContext];
    glClearColor(0.0, 0.0, 0.0, 1.0); // 배경색 (검정)
    
    // Live2D OpenGL 초기화 (네이티브 C++ 호출 가능)
    nativeOnSurfaceCreated();
}

// Flutter에서 iOS 네이티브 OpenGL 해제
- (void)dealloc {
    nativeOnDestroy();
}

// 네이티브 OpenGL 함수 연결
extern void nativeOnSurfaceCreated();
extern void nativeOnDestroy();

@end
