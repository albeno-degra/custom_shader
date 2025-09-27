import 'dart:ui' as ui;

import 'package:custom_shader/checkerboard_shader/shader_cache.dart';
import 'package:flutter/material.dart';

class CheckerboardShaderWidget extends StatefulWidget {
  const CheckerboardShaderWidget({
    required this.child,
    required this.chessboardWidth,
    this.isTransparent = true,

    super.key,
  });
  final Widget child;
  final bool isTransparent;
  final double chessboardWidth;

  @override
  State<CheckerboardShaderWidget> createState() =>
      _CheckerboardShaderWidgetState();
}

class _CheckerboardShaderWidgetState extends State<CheckerboardShaderWidget> {
  late Future<ui.FragmentProgram> _program;

  @override
  void initState() {
    super.initState();
    loadMyShader();
  }

  Future<void> loadMyShader() async {
    _program = ShaderCache.checkerboardProgram;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isTransparent) {
      return widget.child;
    }
    return FutureBuilder<ui.FragmentProgram>(
      future: _program,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            final shader = snapshot.data!.fragmentShader()
              ..setFloat(0, widget.chessboardWidth)
              ..setFloat(1, widget.chessboardWidth)
              ..setFloat(2, 233 / 255)
              ..setFloat(3, 233 / 255)
              ..setFloat(4, 233 / 255)
              ..setFloat(5, 254 / 255)
              ..setFloat(6, 254 / 255)
              ..setFloat(7, 254 / 255);
            return shader;
          },
          child: widget.child,
        );
      },
    );
  }
}
