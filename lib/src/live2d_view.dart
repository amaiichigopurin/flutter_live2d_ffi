import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'live2d_bridge.dart';

class Live2DView extends StatefulWidget {
  const Live2DView({super.key});

  @override
  State<Live2DView> createState() => _Live2DViewState();
}

class _Live2DViewState extends State<Live2DView> {
  @override
  void initState() {
    super.initState();
    Live2D.nativeOnStart();
  }

  @override
  void dispose() {
    Live2D.nativeOnDestroy();
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
        Live2D.nativeOnTouchesBegan(offset.dx, offset.dy);
      },
      onPanUpdate: (details) {
        final offset = _convertTouchToLive2D(details.localPosition);
        Live2D.nativeOnTouchesMoved(offset.dx, offset.dy);
      },
      onPanEnd: (details) {
        Live2D.nativeOnTouchesEnded(0, 0); // 터치 종료 시 좌표 없음
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
