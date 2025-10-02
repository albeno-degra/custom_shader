import 'package:custom_shader/features/pokemons/widgets/pokemons_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(backgroundColor: Colors.white, body: PokemonsWidget()),
    ),
  );
}
