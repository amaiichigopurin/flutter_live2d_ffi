package com.glitch9.flutter_live2d_ffi;

import android.content.Context;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.StandardMessageCodec;

public class Live2DPlatformViewFactory extends PlatformViewFactory {
    public Live2DPlatformViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        return new Live2DPlatformView(context);
    }
}
