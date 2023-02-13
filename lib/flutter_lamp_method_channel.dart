import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_lamp_platform_interface.dart';

/// An implementation of [FlutterLampPlatform] that uses method channels.
class MethodChannelFlutterLamp extends FlutterLampPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('github.com/bigyao25/flutter_lamp');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> hasLamp() async {
    return await methodChannel.invokeMethod<bool>('hasLamp');
  }

  @override
  Future turn(bool on) async {
    return await methodChannel.invokeMethod('turn', {'on': on});
  }
}
