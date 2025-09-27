import 'dart:ui' as ui;

import 'package:custom_shader/checkerboard_shader/checkerboard_shader_widget.dart';
import 'package:flutter/material.dart';

const double chessboardWidth = 48;
const Color dashColor = ui.Color.fromARGB(255, 13, 148, 238);
const Color backgroundColor = ui.Color.fromARGB(255, 255, 255, 255);

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            MagicBackground(),
            Center(child: MagicDash()),
          ],
        ),
      ),
    ),
  );
}

class MagicBackground extends StatefulWidget {
  const MagicBackground({
    super.key,
  });

  @override
  State<MagicBackground> createState() => _MagicBackgroundState();
}

class _MagicBackgroundState extends State<MagicBackground> {
  bool isTransparent = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTransparent = !isTransparent;
        });
      },
      child: CheckerboardShaderWidget(
        isTransparent: isTransparent,
        chessboardWidth: chessboardWidth,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: backgroundColor,
        ),
      ),
    );
  }
}

class MagicDash extends StatefulWidget {
  const MagicDash({
    super.key,
  });

  @override
  State<MagicDash> createState() => _MagicDashState();
}

class _MagicDashState extends State<MagicDash> {
  bool isTransparent = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTransparent = !isTransparent;
        });
      },
      child: CheckerboardShaderWidget(
        isTransparent: isTransparent,
        chessboardWidth: chessboardWidth,
        child: const Icon(
          Icons.flutter_dash,
          size: 200,
          color: dashColor,
        ),
      ),
    );
  }
}
