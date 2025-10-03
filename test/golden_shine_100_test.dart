import 'dart:ui' as ui;

import 'package:custom_shader/shaders/golden_shine_shader/golden_shine_shader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final Future<ui.FragmentProgram> program = ui.FragmentProgram.fromAsset(
  'shaders/golden_shine.frag',
);
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  testWidgets('GoldenShine golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFFD2B48C),
          body: Center(
            child: GoldenShineShaderWidget(
              program: program,
              child: Container(
                width: 300,
                height: 300,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await expectLater(
      find.byType(GoldenShineShaderWidget),
      matchesGoldenFile('golden_shine_100_test.golden.png'),
    );
  });
}
