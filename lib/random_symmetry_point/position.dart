part of random_symmetry_point;
class Position {
  const Position(this.x, this.y);

  final int x;
  final int y;

  @override
  String toString() {
    return 'Position{x:$x,y:$y}';
  }
}