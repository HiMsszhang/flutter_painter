part of digital_display_tube;

class SingleDigitalWidget extends StatelessWidget {
  SingleDigitalWidget({
    super.key,
    required this.width,
    this.color = Colors.black,
    DigitalPath? digitalPath,
    required this.value,
  }) : digitalPath = digitalPath ?? DigitalPath();

  final double width;
  final Color color;
  final int value;
  final DigitalPath digitalPath;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * DigitalPath.kDigitalRate),
      painter: DigitalPainter(
        digitalPath: digitalPath,
        color: color,
        value: value,
        width: width,
      ),
    );
  }
}
