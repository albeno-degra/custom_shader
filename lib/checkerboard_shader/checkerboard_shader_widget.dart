import 'dart:ui' as ui;

import 'package:custom_shader/checkerboard_shader/shader_cache.dart';
import 'package:flutter/material.dart';

const kAlpha = 255;

class CheckerboardShaderWidget extends StatefulWidget {
  const CheckerboardShaderWidget({
    required this.child,
    required this.chessboardWidth,
    this.isTransparent = true,
    this.color1 = const Color.fromARGB(kAlpha, 233, 233, 233),
    this.color2 = const Color.fromARGB(kAlpha, 254, 254, 254),
    super.key,
  });
  final Widget child;
  final bool isTransparent;
  final double chessboardWidth;
  final Color color1;
  final Color color2;

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
              ..setFloat(2, widget.color1.r)
              ..setFloat(3, widget.color1.g)
              ..setFloat(4, widget.color1.b)
              ..setFloat(5, widget.color2.r)
              ..setFloat(6, widget.color2.g)
              ..setFloat(7, widget.color2.b);
            return shader;
          },
          child: widget.child,
        );
      },
    );
  }
}
