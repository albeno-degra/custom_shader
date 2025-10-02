import 'dart:async';
import 'dart:ui' as ui;

import 'package:custom_shader/features/photo_shimmer.dart/widgets/photo_shimmer.dart';
import 'package:flutter/material.dart';

class ImageLoader {
  ImageLoader._();

  static final ImageLoader instance = ImageLoader._();

  final Map<String, ShimmerColors> _cache = {};

  Future<ui.Image> _loadImageFromProvider(ImageProvider provider) {
    final completer = Completer<ui.Image>();
    final stream = provider.resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;

    listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    });

    stream.addListener(listener);

    return completer.future;
  }

  Future<ShimmerColors> getTwoMainColors(ImageProvider provider) async {
    if (_cache.containsKey(provider.toString())) {
      return _cache[provider.toString()]!;
    }
    final image = await _loadImageFromProvider(provider);
    final byteData = await image.toByteData();
    if (byteData == null) return (Colors.black, Colors.white);

    final pixels = byteData.buffer.asUint8List();
    final Map<int, int> colorCount = {};

    for (int i = 0; i < pixels.length; i += 4) {
      final int r = (pixels[i] ~/ 32) * 32;
      final int g = (pixels[i + 1] ~/ 32) * 32;
      final int b = (pixels[i + 2] ~/ 32) * 32;
      final int key = (r << 16) + (g << 8) + b;
      colorCount[key] = (colorCount[key] ?? 0) + 1;
    }

    final sorted = colorCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final Color main1 = sorted.isNotEmpty
        ? Color(0xFF000000 + sorted[0].key)
        : Colors.black;
    final Color main2 = sorted.length > 1
        ? Color(0xFF000000 + sorted[1].key)
        : Colors.white;
    _cache[provider.toString()] = (main1, main2);
    return (main1, main2);
  }
}
