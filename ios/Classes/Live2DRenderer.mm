#import <OpenGLES/ES3/gl.h>

extern "C" void drawLive2D() {
    glClear(GL_COLOR_BUFFER_BIT);
    // Live2D OpenGL 렌더링 호출
}

NSString* loadShaderFromFile(NSString* filename) {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil inDirectory:@"shaders"];
    NSError *error;
    NSString *shaderCode = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];

    if (error) {
        NSLog(@"Failed to load shader file: %@", filename);
        return nil;
    }
    return shaderCode;
}

// 셰이더 로드 및 OpenGL ES에서 사용
NSString* vertexShaderCode = loadShaderFromFile(@"VertSprite.vert");
NSString* fragmentShaderCode = loadShaderFromFile(@"FragSprite.frag");
GLuint vertexShader = compileShader(GL_VERTEX_SHADER, vertexShaderCode.UTF8String);
GLuint fragmentShader = compileShader(GL_FRAGMENT_SHADER, fragmentShaderCode.UTF8String);
