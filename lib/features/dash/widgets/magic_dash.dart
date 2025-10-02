part of 'dash_widgets_props.dart';

class MagicDash extends StatefulWidget {
  const MagicDash({
    super.key,
  });

  @override
  State<MagicDash> createState() => _MagicDashState();
}

class _MagicDashState extends State<MagicDash> {
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
        child: const Icon(
          Icons.flutter_dash,
          size: 200,
          color: dashColor,
        ),
      ),
    );
  }
}
