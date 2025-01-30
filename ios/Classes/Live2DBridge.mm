#import "Live2DBridge.h"
#import <Flutter/Flutter.h>
#include "Live2DCubismCore.h"

csmMoc* moc = nullptr;
csmModel* model = nullptr;

extern "C" void initLive2D(const char* mocPath) {
    FILE* file = fopen(mocPath, "rb");
    if (!file) {
        NSLog(@"[Live2D] Failed to open MOC3 file.");
        return;
    }

    fseek(file, 0, SEEK_END);
    long fileSize = ftell(file);
    rewind(file);

    char* buffer = (char*)malloc(fileSize);
    fread(buffer, 1, fileSize, file);
    fclose(file);

    moc = csmReviveMocInPlace(buffer, fileSize);
    if (!moc) {
        NSLog(@"[Live2D] Failed to revive MOC.");
        free(buffer);
        return;
    }

    unsigned int modelSize = csmGetSizeofModel(moc);
    void* modelMemory = malloc(modelSize);

    model = csmInitializeModelInPlace(moc, modelMemory, modelSize);
    if (!model) {
        NSLog(@"[Live2D] Failed to initialize model.");
        free(moc);
        free(buffer);
        return;
    }

    NSLog(@"[Live2D] Model initialized successfully.");
}

extern "C" void updateLive2D() {
    if (!model) return;
    csmUpdateModel(model);
}

extern "C" void disposeLive2D() {
    if (model) {
        free(model);
        model = nullptr;
    }
    if (moc) {
        free(moc);
        moc = nullptr;
    }
}
