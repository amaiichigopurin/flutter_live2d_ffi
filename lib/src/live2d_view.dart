import 'package:flutter/material.dart';
import 'dart:io';

class Live2DView extends StatelessWidget {
  const Live2DView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const AndroidView(
        viewType: 'live2d_view',
      );
    } else if (Platform.isIOS) {
      return const UiKitView(
        viewType: 'live2d_view',
      );
    } else {
      return const Center(child: Text('Live2D is not supported on this platform.'));
    }
  }
}
