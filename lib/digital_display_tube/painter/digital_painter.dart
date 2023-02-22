part of digital_display_tube;

class DigitalPainter extends CustomPainter {
  DigitalPainter({
    required this.digitalPath,
    required this.color,
    required this.value,
    required this.width,
  });

  final DigitalPath digitalPath;
  final Color color;
  final int value;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    Paint mainPainter = Paint();
    Path path2 = digitalPath.buildPath(value, width);
    canvas.drawPath(path2, mainPainter..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
