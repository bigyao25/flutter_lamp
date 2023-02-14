import 'flutter_lamp_platform_interface.dart';

class FlutterLamp {
  Future<String?> getPlatformVersion() {
    return FlutterLampPlatform.instance.getPlatformVersion();
  }

  Future<bool?> hasLamp() {
    return FlutterLampPlatform.instance.hasLamp();
  }

  Future turn(bool on, {double intensity = 1.0}) {
    return FlutterLampPlatform.instance.turn(on, intensity);
  }
}
