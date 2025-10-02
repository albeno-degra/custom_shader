import 'dart:ui' as ui;

import 'package:custom_shader/shaders/shader_cache.dart';
import 'package:flutter/material.dart';

class FlickBoxesShaderWidget extends StatefulWidget {
  const FlickBoxesShaderWidget({
    required this.child,
    this.color1 = const ui.Color.fromARGB(255, 116, 221, 37),
    this.color2 = const ui.Color.fromARGB(255, 49, 132, 247),
    this.elementSize = 20,
    this.animationSpeed = 10,
    super.key,
  });
  final Widget child;
  final double elementSize;
  final double animationSpeed;
  final Color color1;
  final Color color2;

  @override
  State<FlickBoxesShaderWidget> createState() => _FlickBoxesShaderWidgetState();
}

class _FlickBoxesShaderWidgetState extends State<FlickBoxesShaderWidget>
    with SingleTickerProviderStateMixin {
  late Future<ui.FragmentProgram> _program;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    loadMyShader();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadMyShader() async {
    _program = ShaderCache.stainsProgram;
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
                final shader = snapshot.data!.fragmentShader()
                  ..setFloat(0, widget.color1.r)
                  ..setFloat(1, widget.color1.g)
                  ..setFloat(2, widget.color1.b)
                  ..setFloat(3, widget.color2.r)
                  ..setFloat(4, widget.color2.g)
                  ..setFloat(5, widget.color2.b)
                  ..setFloat(6, widget.elementSize)
                  ..setFloat(
                    7,
                    _controller.value * widget.animationSpeed,
                  );
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
