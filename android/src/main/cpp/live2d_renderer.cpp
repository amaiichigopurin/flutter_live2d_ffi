#include "live2d_renderer.h"
#include <iostream>

Live2DRenderer& Live2DRenderer::getInstance() {
    static Live2DRenderer instance;
    return instance;
}

Live2DRenderer::Live2DRenderer() {
    // OpenGL 초기화
}

Live2DRenderer::~Live2DRenderer() {}

void Live2DRenderer::loadModel(const char* modelPath) {
    std::cout << "Loading Live2D Model: " << modelPath << std::endl;
}

void Live2DRenderer::update() {
    // Live2D 모델 애니메이션 업데이트
}

void Live2DRenderer::render() {
    glClear(GL_COLOR_BUFFER_BIT);
    // OpenGL로 Live2D 모델 렌더링
}
