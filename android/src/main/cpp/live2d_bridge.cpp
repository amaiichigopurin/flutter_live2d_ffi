#include <jni.h>
#include <iostream>

extern "C" {
    void nativeOnStart() {
        std::cout << "Live2D OnStart" << std::endl;
    }

    void nativeOnPause() {
        std::cout << "Live2D OnPause" << std::endl;
    }

    void nativeOnStop() {
        std::cout << "Live2D OnStop" << std::endl;
    }

    void nativeOnDestroy() {
        std::cout << "Live2D OnDestroy" << std::endl;
    }

    void nativeOnSurfaceCreated() {
        std::cout << "Surface Created" << std::endl;
    }

    void nativeOnSurfaceChanged(int width, int height) {
        std::cout << "Surface Changed: " << width << " x " << height << std::endl;
    }

    void nativeOnDrawFrame() {
        std::cout << "Drawing Frame" << std::endl;
    }

    void nativeOnTouchesBegan(float pointX, float pointY) {
        std::cout << "Touch Began at: (" << pointX << ", " << pointY << ")" << std::endl;
    }

    void nativeOnTouchesEnded(float pointX, float pointY) {
        std::cout << "Touch Ended at: (" << pointX << ", " << pointY << ")" << std::endl;
    }

    void nativeOnTouchesMoved(float pointX, float pointY) {
        std::cout << "Touch Moved at: (" << pointX << ", " << pointY << ")" << std::endl;
    }
}
