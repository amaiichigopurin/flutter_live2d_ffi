package com.glitch9.flutter_live2d_ffi;

import android.content.Context;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import io.flutter.plugin.platform.PlatformView;

public class Live2DPlatformView implements PlatformView {
    private final SurfaceView surfaceView;

    Live2DPlatformView(Context context) {
        surfaceView = new SurfaceView(context);
        surfaceView.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override
            public void surfaceCreated(SurfaceHolder holder) {
                // Live2D OpenGL 초기화
                nativeOnSurfaceCreated();
            }

            @Override
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
                nativeOnSurfaceChanged(width, height);
            }

            @Override
            public void surfaceDestroyed(SurfaceHolder holder) {
                nativeOnDestroy();
            }
        });
    }

    @Override
    public View getView() {
        return surfaceView;
    }

    @Override
    public void dispose() {
    }

    // 네이티브 함수 호출 (JNI 또는 FFI)
    private native void nativeOnSurfaceCreated();
    private native void nativeOnSurfaceChanged(int width, int height);
    private native void nativeOnDestroy();
}
