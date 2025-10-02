import 'package:custom_shader/features/dash/widgets/dash_widgets_props.dart';
import 'package:flutter/material.dart';

class DashWidget extends StatelessWidget {
  const DashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        MagicBackground(),
        Center(child: MagicDash()),
      ],
    );
  }
}
