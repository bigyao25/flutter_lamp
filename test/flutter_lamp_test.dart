import 'package:flutter_lamp/flutter_lamp.dart';
import 'package:flutter_lamp/flutter_lamp_method_channel.dart';
import 'package:flutter_lamp/flutter_lamp_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLampPlatform with MockPlatformInterfaceMixin implements FlutterLampPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> hasLamp() {
    // TODO: implement hasLamp
    throw UnimplementedError();
  }

  @override
  Future turn(bool on, double intensity) {
    // TODO: implement turn
    throw UnimplementedError();
  }
}

void main() {
  final FlutterLampPlatform initialPlatform = FlutterLampPlatform.instance;

  test('$MethodChannelFlutterLamp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLamp>());
  });

  test('getPlatformVersion', () async {
    FlutterLamp flutterLampPlugin = FlutterLamp();
    MockFlutterLampPlatform fakePlatform = MockFlutterLampPlatform();
    FlutterLampPlatform.instance = fakePlatform;

    expect(await flutterLampPlugin.getPlatformVersion(), '42');
  });
}
