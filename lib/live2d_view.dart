import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter_live2d_ffi/flutter_live2d_ffi.dart';

/* 

pubspec.yaml 리소스 예제

flutter:
  assets:
    - assets/live2d/haru/haru.model3.json
    - assets/live2d/haru/haru.moc3
    - assets/live2d/haru/textures/texture_00.png
    - assets/live2d/haru/textures/texture_01.png
    - assets/live2d/haru/textures/texture_02.png
    - assets/live2d/haru/motions/motion_idle.motion3.json
    - assets/live2d/haru/motions/motion_wave.motion3.json
*/

class Live2DView extends StatefulWidget {
  final String modelPath;
  const Live2DView(this.modelPath, {super.key});

  @override
  State<Live2DView> createState() => _Live2DViewState();
}

class _Live2DViewState extends State<Live2DView> {
  @override
  void initState() {
    super.initState();
    _loadModelAndStart();
  }

  Future<void> _loadModelAndStart() async {
    try {
      // 위의 예제라면 "assets/live2d/haru/haru.model3.json"을 로드
      await FlutterLive2DFFI.loadModel(widget.modelPath);
    } on PlatformException catch (e) {
      print('Failed to load model: ${e.message}');
    }

    try {
      await FlutterLive2DFFI.nativeOnStart();
    } on PlatformException catch (e) {
      print('Failed to start Live2D: ${e.message}');
    }
  }

  @override
  void dispose() {
    FlutterLive2DFFI.nativeOnDestroy();
    super.dispose();
  }

  Widget _resolveWidget() {
    if (Platform.isAndroid) {
      return const AndroidView(
        viewType: 'live2d_view', // 네이티브 Android View 등록 필요
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (Platform.isIOS) {
      return const UiKitView(
        viewType: 'live2d_view', // 네이티브 iOS View 등록 필요
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return const Center(child: Text('Live2D is not supported on this platform.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final offset = _convertTouchToLive2D(details.localPosition);
        FlutterLive2DFFI.nativeOnTouchesBegan(offset.dx, offset.dy);
      },
      onPanUpdate: (details) {
        final offset = _convertTouchToLive2D(details.localPosition);
        FlutterLive2DFFI.nativeOnTouchesMoved(offset.dx, offset.dy);
      },
      onPanEnd: (details) {
        FlutterLive2DFFI.nativeOnTouchesEnded(0, 0); // 터치 종료 시 좌표 없음
      },
      child: _resolveWidget(),
    );
  }

  /// 🛠 Live2D 좌표계 변환 (NDC 변환 고려)
  Offset _convertTouchToLive2D(Offset localPosition) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final Size size = box.size;
      final double normalizedX = (localPosition.dx / size.width) * 2 - 1; // -1 ~ 1로 변환
      final double normalizedY = -((localPosition.dy / size.height) * 2 - 1); // Y축 반전
      return Offset(normalizedX, normalizedY);
    }
    return localPosition;
  }
}
