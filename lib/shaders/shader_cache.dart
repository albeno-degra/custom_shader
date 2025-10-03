import 'dart:ui' as ui;

const String shaderAssetKey = 'shaders/checkerboard.frag';
const String stainsAssetKey = 'shaders/pixel_flicker.frag';
const String goldenShineAssetKey = 'shaders/golden_shine.frag';

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

  static Future<ui.FragmentProgram>? _goldenShineProgram;
  static Future<ui.FragmentProgram> get goldenShineProgram {
    _goldenShineProgram ??= ui.FragmentProgram.fromAsset(goldenShineAssetKey);
    return _goldenShineProgram!;
  }
}
