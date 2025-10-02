part of 'dash_widgets_props.dart';

class MagicBackground extends StatefulWidget {
  const MagicBackground({
    super.key,
  });

  @override
  State<MagicBackground> createState() => _MagicBackgroundState();
}

class _MagicBackgroundState extends State<MagicBackground> {
  bool isTransparent = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTransparent = !isTransparent;
        });
      },
      child: CheckerboardShaderWidget(
        isTransparent: isTransparent,
        chessboardWidth: chessboardWidth,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: backgroundColor,
        ),
      ),
    );
  }
}
