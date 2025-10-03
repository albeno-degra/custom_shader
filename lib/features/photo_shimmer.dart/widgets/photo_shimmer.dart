import 'package:custom_shader/core/image_loader.dart';
import 'package:custom_shader/shaders/flick_box_shader/flick_boxes_shader_widget.dart';
import 'package:custom_shader/shaders/golden_shine_shader/golden_shine_shader_widget.dart';
import 'package:flutter/material.dart';

typedef ShimmerColors = (Color color1, Color color2);

enum ShimmerType { flickBoxes, goldenShine }

class GoldenShineShaderParams {
  const GoldenShineShaderParams({
    this.numSpots = 14.0,
    this.minRadius = 0.10,
    this.maxRadius = 0.16,
    this.minCenterPos = 0.2,
    this.maxCenterPos = 0.8,
  });
  final double numSpots;
  final double minRadius;
  final double maxRadius;
  final double minCenterPos;
  final double maxCenterPos;
}

class PhotoShimmer extends StatefulWidget {
  const PhotoShimmer({
    required this.image,
    this.shimmerType = ShimmerType.flickBoxes,
    this.size = const Size(150, 150),
    this.shimmerGridSize = 20,
    this.shimmerSpeed = 35,
    this.goldenShineShaderParams = const GoldenShineShaderParams(),
    super.key,
  });

  final ShimmerType shimmerType;
  final ImageProvider image;
  final Size size;
  final double shimmerGridSize;
  final double shimmerSpeed;
  final GoldenShineShaderParams goldenShineShaderParams;

  @override
  State<PhotoShimmer> createState() => _PhotoShimmerState();
}

class _PhotoShimmerState extends State<PhotoShimmer> {
  late final Future<void> _getColorsFuture;
  ShimmerColors? colors;
  ValueNotifier<bool> isShimmered = ValueNotifier(true);
  ImageProvider? _imageProvider;

  @override
  void initState() {
    super.initState();
    _imageProvider ??= widget.image;
    if (widget.shimmerType == ShimmerType.flickBoxes) {
      _getColorsFuture = _fetchColors();
    }
  }

  Future<void> _fetchColors() async {
    final twoMainColors = await ImageLoader.instance.getTwoMainColors(
      _imageProvider!,
    );
    colors = twoMainColors;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: GestureDetector(
        onTap: () {
          isShimmered.value = !isShimmered.value;
        },
        child: switch (widget.shimmerType) {
          ShimmerType.flickBoxes => FutureBuilder(
            future: _getColorsFuture,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState != ConnectionState.done) {
                return const SizedBox.expand();
              }
              return ValueListenableBuilder<bool>(
                valueListenable: isShimmered,
                builder: (context, isShimmered, child) {
                  if (!isShimmered) {
                    return Image(
                      image: _imageProvider!,
                      fit: BoxFit.cover,
                      height: widget.size.height,
                    );
                  }
                  return FlickBoxesShaderWidget(
                    color1: colors!.$1,
                    color2: colors!.$2,
                    animationSpeed: widget.shimmerSpeed,
                    elementSize: widget.shimmerGridSize,
                    child: Image(
                      image: _imageProvider!,
                      fit: BoxFit.cover,
                      height: widget.size.height,
                    ),
                  );
                },
              );
            },
          ),
          ShimmerType.goldenShine => ValueListenableBuilder<bool>(
            valueListenable: isShimmered,
            builder: (context, isShimmered, child) {
              if (!isShimmered) {
                return Image(
                  image: _imageProvider!,
                  fit: BoxFit.cover,
                  height: widget.size.height,
                );
              }
              return GoldenShineShaderWidget(
                goldenShineShaderParams: widget.goldenShineShaderParams,
                child: Image(
                  image: _imageProvider!,
                  fit: BoxFit.cover,
                  height: widget.size.height,
                ),
              );
            },
          ),
        },
      ),
    );
  }
}
