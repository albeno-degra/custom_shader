import 'package:custom_shader/core/image_loader.dart';
import 'package:custom_shader/shaders/flick_box_shader/flick_boxes_shader_widget.dart';
import 'package:flutter/material.dart';

typedef ShimmerColors = (Color color1, Color color2);

enum ShimmerType { flickBoxes }

class PhotoShimmer extends StatefulWidget {
  const PhotoShimmer({
    required this.imageUrl,
    this.shimmerType = ShimmerType.flickBoxes,
    this.size = const Size(150, 150),
    this.shimmerGridSize = 20,
    this.shimmerSpeed = 35,
    super.key,
  });

  final ShimmerType shimmerType;
  final String imageUrl;
  final Size size;
  final double shimmerGridSize;
  final double shimmerSpeed;

  @override
  State<PhotoShimmer> createState() => _PhotoShimmerState();
}

class _PhotoShimmerState extends State<PhotoShimmer> {
  late final Future<void> _getColorsFuture;
  ShimmerColors? colors;
  bool isShimmered = true;
  ImageProvider? _imageProvider;

  @override
  void initState() {
    super.initState();
    _getColorsFuture = _fetchColors();
  }

  Future<void> _fetchColors() async {
    _imageProvider ??= NetworkImage(widget.imageUrl);
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
          setState(() {
            isShimmered = !isShimmered;
          });
        },
        child: FutureBuilder(
          future: _getColorsFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState != ConnectionState.done) {
              return const SizedBox.expand();
            }
            if (!isShimmered) {
              return Image(
                image: _imageProvider!,
                fit: BoxFit.cover,
                height: widget.size.height,
              );
            }
            return switch (widget.shimmerType) {
              ShimmerType.flickBoxes => FlickBoxesShaderWidget(
                color1: colors!.$1,
                color2: colors!.$2,
                animationSpeed: widget.shimmerSpeed,
                elementSize: widget.shimmerGridSize,
                child: Image(
                  image: _imageProvider!,
                  fit: BoxFit.cover,
                  height: widget.size.height,
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}
