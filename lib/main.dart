import 'package:custom_shader/features/golden_shine/widgets/golden_shine_widget.dart';
import 'package:flutter/material.dart';

const Color tan = Color(0xFFD2B48C);

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: tan,
        body: GoldenShineWidget(),
      ),
    ),
  );
}
