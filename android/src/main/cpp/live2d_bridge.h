#ifndef LIVE2D_BRIDGE_H
#define LIVE2D_BRIDGE_H

#ifdef __cplusplus
extern "C" {
#endif

// 라이브2D 엔진 초기화 및 정리
void nativeOnStart();
void nativeOnPause();
void nativeOnStop();
void nativeOnDestroy();

// OpenGL 서페이스 관련
void nativeOnSurfaceCreated();
void nativeOnSurfaceChanged(int width, int height);
void nativeOnDrawFrame();

// 터치 이벤트
void nativeOnTouchesBegan(float pointX, float pointY);
void nativeOnTouchesEnded(float pointX, float pointY);
void nativeOnTouchesMoved(float pointX, float pointY);

#ifdef __cplusplus
}
#endif

#endif // LIVE2D_BRIDGE_H
