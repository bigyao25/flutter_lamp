import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_lamp_method_channel.dart';

abstract class FlutterLampPlatform extends PlatformInterface {
  /// Constructs a FlutterLampPlatform.
  FlutterLampPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLampPlatform _instance = MethodChannelFlutterLamp();

  /// The default instance of [FlutterLampPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLamp].
  static FlutterLampPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLampPlatform] when
  /// they register themselves.
  static set instance(FlutterLampPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> hasLamp() {
    throw UnimplementedError('hasLamp() has not been implemented.');
  }

  Future turn(bool on) {
    throw UnimplementedError('turn() has not been implemented.');
  }
}
