import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter unit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wi-Fi connect'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  Future<void> _startScan(BuildContext context) async {
    // check if can-startScan
    final can = await WiFiScan.instance.canStartScan();
    // if can-not, then show error
    if (can != CanStartScan.yes) {
      if (mounted) print("Cannot start scan: $can");
      return;
    }

    // call startScan API
    final result = await WiFiScan.instance.startScan();
    if (mounted) print("startScan: $result");
    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    // check if can-getScannedResults
    final can = await WiFiScan.instance.canGetScannedResults();
    // if can-not, then show error
    if (can != CanGetScannedResults.yes) {
      if (mounted) print("Cannot get scanned results: $can");
      accessPoints = <WiFiAccessPoint>[];
      return false;
    }

    return true;
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable.listen((result) => setState(() => accessPoints = result));
    }
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
    setState(() => subscription = null);
  }

  //获取权限
  @override
  void initState() {
    _startListeningToScanResults(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // stop subscription for scanned results
    _stopListeningToScanResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: accessPoints.length,
          itemBuilder: (_, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return _ConnectDialog(
                      accessPoint: accessPoints[index],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_rounded),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(accessPoints[index].ssid),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        print('查看Wi-Fi详情');
                      },
                      child: const Icon(
                        Icons.info_outline,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _ConnectDialog extends StatefulWidget {
  final WiFiAccessPoint accessPoint;

  const _ConnectDialog({
    super.key,
    required this.accessPoint,
  });

  @override
  State<_ConnectDialog> createState() => _ConnectDialogState();
}

class _ConnectDialogState extends State<_ConnectDialog> {
  String? _password;

  void _onConnect() {
    if (_password == null || _password!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请输入密码')));
      return;
    } else {
      print('开始连接:$_password/n ${widget.accessPoint.ssid}/n${widget.accessPoint.bssid}');
      PluginWifiConnect.connectToSecureNetwork(widget.accessPoint.ssid, _password!).then((value) {
        if (value!) print('连接成功');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * (1 / 3),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('连接到${widget.accessPoint.ssid}'),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      hintText: "输入密码",
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      // border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                ),
                // Container(
                //   height: 50,
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey.shade400),
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                //   margin: const EdgeInsets.symmetric(horizontal: 16),
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Row(),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        //TODO 连接到选中Wi-Fi
                        print('取消');

                        Navigator.pop(context);
                      },
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: _onConnect,
                      child: const Text('连接'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
