part of digital_display_tube;

enum NumberType {
  single, //单个数字
  multi //多个数字
}

class DigitalDisplayTubePage extends StatefulWidget {
  const DigitalDisplayTubePage({Key? key}) : super(key: key);

  @override
  State<DigitalDisplayTubePage> createState() => _DigitalDisplayTubePageState();
}

class _DigitalDisplayTubePageState extends State<DigitalDisplayTubePage> {
  int _numValue = 1;
  NumberType _numberType = NumberType.single;

  @override
  Widget build(BuildContext context) {
    final bool showIncrement = _numberType == NumberType.multi;
    return Scaffold(
      appBar: AppBar(
        title: const Text('数字显示管'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _numberType == NumberType.single
                ? SingleDigitalWidget(
                    value: _numValue,
                    width: 40,
                  )
                : MultiDigitalWidget(
                    width: 30,
                    value: _numValue,
                    count: 4,
                    spacing: 5,
                  ),
            const SizedBox(height: 60),
            TextButton(
                onPressed: () {
                  setState(() {
                    _numberType = _numberType == NumberType.multi ? NumberType.single : NumberType.multi;
                    if (_numberType == NumberType.single) {
                      _numValue = _numValue % 10;
                    }
                  });
                },
                child: const Text('切换单/多个数字')),
          ],
        ),
      ),
      floatingActionButton: showIncrement
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : const SizedBox(),
    );
  }

  _incrementCounter() {
    HapticFeedback.mediumImpact();
    setState(() {
      _numValue++;
    });
  }
}
