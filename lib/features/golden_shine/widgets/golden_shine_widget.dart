import 'package:custom_shader/features/photo_shimmer.dart/widgets/photo_shimmer.dart';
import 'package:custom_shader/shaders/golden_shine_shader/golden_shine_shader_widget.dart';
import 'package:flutter/material.dart';

const bigPokemonParams = GoldenShineShaderParams(
  numSpots: 60,
  minRadius: 0.08,
  maxRadius: 0.1,
  minCenterPos: 0.05,
  maxCenterPos: 0.95,
);

const smallPokemonParams = GoldenShineShaderParams(
  numSpots: 80,
  minRadius: 0.08,
  maxRadius: 0.1,
  minCenterPos: 0.05,
  maxCenterPos: 0.95,
);

const textParams = GoldenShineShaderParams(
  numSpots: 30,
  minRadius: 0.08,
  maxRadius: 0.1,
  minCenterPos: 0.05,
  maxCenterPos: 0.95,
);

const smallTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

class GoldenShineWidget extends StatefulWidget {
  const GoldenShineWidget({super.key});

  @override
  State<GoldenShineWidget> createState() => _GoldenShineWidgetState();
}

class _GoldenShineWidgetState extends State<GoldenShineWidget>
    with TickerProviderStateMixin {
  final ValueNotifier<int> _rating = ValueNotifier(0);
  final ValueNotifier<bool> _gotPokemon = ValueNotifier(false);
  final ImageProvider _imageProvider = const NetworkImage(
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/197.png',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(_imageProvider, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ValueListenableBuilder(
        valueListenable: _gotPokemon,
        builder: (context, gotPokemon, child) {
          if (gotPokemon) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoldenPokemon(
                    size: Size(screenSize.width, screenSize.height / 2),
                    image: _imageProvider,
                    goldenShineShaderParams: bigPokemonParams,
                  ),
                  _StartButton(rating: _rating, gotPokemon: _gotPokemon),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () {
                          _rating.value = index + 1;
                          if (index == 4) {
                            showBottomSheet(
                              context: context,
                              transitionAnimationController:
                                  AnimationController(
                                    vsync: this,
                                    duration: const Duration(
                                      milliseconds: 400,
                                    ),
                                  ),
                              builder: (context) => _BottomModalSheet(
                                screenSize: screenSize,
                                imageProvider: _imageProvider,
                                gotPokemon: _gotPokemon,
                              ),
                            );
                          }
                        },
                        child: ValueListenableBuilder(
                          valueListenable: _rating,
                          builder: (context, rating, child) {
                            return GoldenShineShaderWidget(
                              child: Icon(
                                rating > index
                                    ? Icons.star
                                    : Icons.star_outline_outlined,
                                color: Colors.white,
                                size: screenSize.width / 5 - (24 / 5),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 92),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _BottomModalSheet extends StatelessWidget {
  const _BottomModalSheet({
    required this.screenSize,
    required ImageProvider<Object> imageProvider,
    required ValueNotifier<bool> gotPokemon,
  }) : _imageProvider = imageProvider,
       _gotPokemon = gotPokemon;

  final Size screenSize;
  final ImageProvider<Object> _imageProvider;
  final ValueNotifier<bool> _gotPokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: RepaintBoundary(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GoldenShineShaderWidget(
              goldenShineShaderParams: textParams,
              child: Column(
                children: [
                  Text(
                    'You found a secret!',
                    style: smallTextStyle,
                  ),

                  SizedBox(height: 8),
                  Text(
                    'Here is a golden Pokemon!',
                    style: smallTextStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _GoldenPokemon(
              size: Size(
                screenSize.width / 3,
                screenSize.height / 5,
              ),
              goldenShineShaderParams: smallPokemonParams,
              image: _imageProvider,
            ),
            GoldenShineShaderWidget(
              goldenShineShaderParams: textParams,
              child: TextButton(
                onPressed: () {
                  _gotPokemon.value = true;
                  Navigator.pop(context);
                },
                child: const Text(
                  'Got it!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({
    required ValueNotifier<int> rating,
    required ValueNotifier<bool> gotPokemon,
  }) : _rating = rating,
       _gotPokemon = gotPokemon;

  final ValueNotifier<int> _rating;
  final ValueNotifier<bool> _gotPokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _rating.value = 0;
        _gotPokemon.value = false;
      },
      child: Container(
        width: double.infinity,
        height: 56,
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Start',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _GoldenPokemon extends StatelessWidget {
  const _GoldenPokemon({
    required this.size,
    required this.goldenShineShaderParams,
    required this.image,
  });

  final Size size;
  final GoldenShineShaderParams goldenShineShaderParams;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return PhotoShimmer(
      image: image,
      size: size,
      shimmerType: ShimmerType.goldenShine,
      goldenShineShaderParams: goldenShineShaderParams,
    );
  }
}
