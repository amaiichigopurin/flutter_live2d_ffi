package com.glitch9.flutter_live2d_ffi;

public class Live2DRenderer {
   private String loadShaderFromAssets(Context context, String filename) {
        StringBuilder shaderCode = new StringBuilder();
        try {
            InputStream inputStream = context.getAssets().open("shaders/" + filename);
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
            String line;
            while ((line = reader.readLine()) != null) {
                shaderCode.append(line).append("\n");
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return shaderCode.toString();
    }

    // 셰이더 로드 및 OpenGL ES에서 사용
    String vertexShaderCode = loadShaderFromAssets(context, "VertSprite.vert");
    String fragmentShaderCode = loadShaderFromAssets(context, "FragSprite.frag");
    int vertexShader = loadShader(GLES20.GL_VERTEX_SHADER, vertexShaderCode);
    int fragmentShader = loadShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderCode);
}
