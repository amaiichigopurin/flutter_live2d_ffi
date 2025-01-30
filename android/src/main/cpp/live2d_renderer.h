#ifndef LIVE2D_RENDERER_H
#define LIVE2D_RENDERER_H

#include <GLES3/gl3.h>

class Live2DRenderer {
public:
    static Live2DRenderer& getInstance();
    void loadModel(const char* modelPath);
    void update();
    void render();

private:
    Live2DRenderer();
    ~Live2DRenderer();
};

#endif
