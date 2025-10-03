import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:custom_shader/features/photo_shimmer.dart/widgets/photo_shimmer.dart';
import 'package:custom_shader/shaders/shader_cache.dart';
import 'package:flutter/material.dart';

class GoldenShineShaderWidget extends StatefulWidget {
  const GoldenShineShaderWidget({
    required this.child,
    this.yellowColor = const ui.Color(0xFFF5DD00),
    this.brownColor = const ui.Color(0xFF695A10),
    this.animationSpeed = 100,
    this.goldenShineShaderParams = const GoldenShineShaderParams(),
    this.program,
    super.key,
  });
  final Widget child;
  final double animationSpeed;
  final Color yellowColor;
  final Color brownColor;
  final GoldenShineShaderParams goldenShineShaderParams;
  final Future<ui.FragmentProgram>? program;

  @override
  State<GoldenShineShaderWidget> createState() =>
      _GoldenShineShaderWidgetState();
}

class _GoldenShineShaderWidgetState extends State<GoldenShineShaderWidget>
    with SingleTickerProviderStateMixin {
  late final Future<ui.FragmentProgram> _program;
  late final AnimationController _controller;
  late final ui.FragmentShader shader;
  late final double randomDouble;

  @override
  void initState() {
    super.initState();
    _program = widget.program ?? ShaderCache.goldenShineProgram;

    final isFromTestEnv = Platform.environment.containsKey('FLUTTER_TEST');
    randomDouble = isFromTestEnv ? 1 : Random().nextDouble();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.FragmentProgram>(
      future: _program,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) {
                final dpr = MediaQuery.devicePixelRatioOf(context);
                final physicalWidth = bounds.width * dpr;
                final physicalHeight = bounds.height * dpr;
                final shader = snapshot.data!.fragmentShader()
                  ..setFloat(
                    0,
                    _controller.value * widget.animationSpeed,
                  )
                  ..setFloat(1, physicalWidth)
                  ..setFloat(2, physicalHeight)
                  ..setFloat(3, randomDouble)
                  ..setFloat(4, widget.yellowColor.r)
                  ..setFloat(5, widget.yellowColor.g)
                  ..setFloat(6, widget.yellowColor.b)
                  ..setFloat(7, widget.brownColor.r)
                  ..setFloat(8, widget.brownColor.g)
                  ..setFloat(9, widget.brownColor.b)
                  ..setFloat(10, widget.goldenShineShaderParams.minRadius)
                  ..setFloat(11, widget.goldenShineShaderParams.maxRadius)
                  ..setFloat(12, widget.goldenShineShaderParams.numSpots)
                  ..setFloat(13, widget.goldenShineShaderParams.minCenterPos)
                  ..setFloat(14, widget.goldenShineShaderParams.maxCenterPos);
                return shader;
              },
              child: widget.child,
            );
          },
        );
      },
    );
  }
}
