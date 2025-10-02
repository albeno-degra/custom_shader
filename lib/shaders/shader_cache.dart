import 'dart:ui' as ui;

const String shaderAssetKey = 'shaders/checkerboard.frag';
const String stainsAssetKey = 'shaders/pixel_flicker.frag';

class ShaderCache {
  static Future<ui.FragmentProgram>? _checkerboardProgram;

  static Future<ui.FragmentProgram> get checkerboardProgram {
    _checkerboardProgram ??= ui.FragmentProgram.fromAsset(shaderAssetKey);
    return _checkerboardProgram!;
  }

  static Future<ui.FragmentProgram>? _stainsProgram;

  static Future<ui.FragmentProgram> get stainsProgram {
    _stainsProgram ??= ui.FragmentProgram.fromAsset(stainsAssetKey);
    return _stainsProgram!;
  }
}
