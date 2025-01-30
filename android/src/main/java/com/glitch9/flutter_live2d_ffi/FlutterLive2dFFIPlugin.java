package com.glitch9.flutter_live2d_ffi;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin; 

/** FlutterLive2DFFIPlugin */
public class FlutterLive2DFFIPlugin implements FlutterPlugin  {
 
  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
      PlatformViewRegistry registry = binding.getPlatformViewRegistry();
      registry.registerViewFactory("live2d_view", new Live2DPlatformViewFactory());
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
      // 여기에 해제 로직 추가 가능
  }   
}
