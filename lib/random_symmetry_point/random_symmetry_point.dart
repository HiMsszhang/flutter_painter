library random_symmetry_point;

import 'dart:math';
import 'package:flutter/material.dart';

part 'portrait_painter.dart';

part 'position.dart';

class RandomSymmetryPointPage extends StatefulWidget {
  const RandomSymmetryPointPage({Key? key}) : super(key: key);

  @override
  State<RandomSymmetryPointPage> createState() => _RandomSymmetryPointPageState();
}

class _RandomSymmetryPointPageState extends State<RandomSymmetryPointPage> {
  final List<Position> _positions = []; //点位
  final Random _random = Random(); //随机数
  final int _blockCount = 9; //矩阵数量

  ///初始化点位
  void _initPosition() {
    _positions.clear(); // 先清空点集

    // 左半边的数量 (随机)
    int randomCount = 2 + _random.nextInt(_blockCount * _blockCount ~/ 2 - 2);
    // 对称轴
    var axis = _blockCount ~/ 2;
    //添加左侧随机点
    for (int i = 0; i < randomCount; i++) {
      int randomX = _random.nextInt(axis + 1);
      int randomY = _random.nextInt(_blockCount);
      var position = Position(randomX, randomY);
      _positions.add(position);
    }
    //添加对称点
    for (int i = 0; i < _positions.length; i++) {
      if (_positions[i].x < _blockCount ~/ 2) {
        _positions.add(Position(2 * axis - _positions[i].x, _positions[i].y));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initPosition();

    debugPrint(_positions.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('随机对称点头像'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: GestureDetector(
            onTap: () => setState(() {}),
            child: CustomPaint(
              painter: PortraitPainter(
                _positions,
                blockCount: _blockCount,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
