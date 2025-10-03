import 'package:custom_shader/features/photo_shimmer.dart/widgets/photo_shimmer.dart';
import 'package:flutter/material.dart';

class PokemonsWidget extends StatefulWidget {
  const PokemonsWidget({super.key});

  @override
  State<PokemonsWidget> createState() => _PokemonsWidgetState();
}

class _PokemonsWidgetState extends State<PokemonsWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 160),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return PhotoShimmer(
          image: NetworkImage(
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${(index + 1) * 3}.png',
          ),
          size: const Size(100, 100),
        );
      },
    );
  }
}
