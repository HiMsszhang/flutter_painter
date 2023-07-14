import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //确定初始化
  runApp(const Paint01App());
  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //全局设置透明
        statusBarIconBrightness: Brightness.light
        //light:黑色图标 dark：白色图标
        //在此处设置statusBarIconBrightness为全局设置
        );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class Paint01App extends StatelessWidget {
  const Paint01App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter unit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Paint01(),
    );
  }
}

class Paint01 extends StatelessWidget {
  const Paint01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(MediaQuery.of(context).size.toString());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ColorAndAntiAliasTest())),
              child: const Text('颜色与抗锯齿属性'),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ColorAndAntiAliasTest())),
              child: const Text('画笔类型与线宽'),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorAndAntiAliasTest extends StatefulWidget {
  const ColorAndAntiAliasTest({
    super.key,
  });

  @override
  State<ColorAndAntiAliasTest> createState() => _ColorAndAntiAliasTestState();
}

class _ColorAndAntiAliasTestState extends State<ColorAndAntiAliasTest> {
  @override
  void initState() {
    super.initState();
    // 强制横屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    super.dispose();
    // 强制横屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        // size: const Size(300, 300),
        painter: ColorAndAntiAliasOfPainter(),
      ),
    );
  }
}

///颜色与抗锯齿
class ColorAndAntiAliasOfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    //蓝色带抗锯齿
    canvas.drawCircle(
        const Offset(170, 180),
        160,
        paint
          ..color = Colors.blue
          ..isAntiAlias = true);
    canvas.drawCircle(
        const Offset(170 + 190 * 2, 180),
        160,
        paint
          ..color = Colors.red
          ..isAntiAlias = false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
