import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lamp/flutter_lamp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterLampPlugin = FlutterLamp();
  final ValueNotifier<double> _notifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _notifier.addListener(() {
      if (_notifier.value < 0.01) {
        _flutterLampPlugin.turn(false);
      } else {
        _flutterLampPlugin.turn(true, intensity: _notifier.value);
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterLampPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (BuildContext context, double value, Widget? child) {
            return Center(
              child: Column(
                children: [
                  Text('Running on: $_platformVersion\n'),
                  ElevatedButton(
                      onPressed: () {
                        _notifier.value = _notifier.value <= 0.01 ? 1 : 0;
                      },
                      child: const Text("Toggle Touch")),
                  Slider(
                    value: value,
                    onChanged: (value) {
                      _notifier.value = value;
                    },
                  ),
                  Text("value: ${_notifier.value}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
