import 'dart:ui' as ui;

const String shaderAssetKey = 'shaders/checkerboard.frag';

class ShaderCache {
  static Future<ui.FragmentProgram>? _program;

  static Future<ui.FragmentProgram> get checkerboardProgram {
    _program ??= ui.FragmentProgram.fromAsset(shaderAssetKey);
    return _program!;
  }
}
