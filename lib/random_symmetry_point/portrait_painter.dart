part of random_symmetry_point;

class PortraitPainter extends CustomPainter {
  late final Paint _paint; //画笔
  final int blockCount; //块数
  final List<Position> positions; //点位
  final Color color;
  final pd = 20.0;

  PortraitPainter(this.positions, {this.blockCount = 9, this.color = Colors.blue}) : _paint = Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)));

    var perW = (size.width - pd * 2) / (blockCount);
    var perH = (size.height - pd * 2) / (blockCount);

    canvas.translate(pd, pd);
    for (var position in positions) {
      _drawBlock(perW, perH, canvas, position);
    }
  }

  void _drawBlock(double dW, double dH, Canvas canvas, Position position) {
    canvas.drawRect(Rect.fromLTWH(position.x * dW.floor() * 1.0, position.y * dH.floor() * 1.0, dW.floor() * 1.0, dH.floor() * 1.0), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
