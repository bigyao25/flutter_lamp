import Flutter
import UIKit

public class FlutterLampPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "github.com/bigyao25/flutter_lamp", binaryMessenger: registrar.messenger())
    let instance = FlutterLampPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let method = call.method
      let args = call.arguments as? [String: Any]
      
      if method == "getPlatformVersion" {
          result("iOS " + UIDevice.current.systemVersion)
      } else if method == "hasLamp" {
          let result = hasLamp()
          result(result)
      } else if method == "turn" else {
          guard let on = args?["on"] else { return false }
          guard let intensity = args?["intensity"] else { return 0 }
          let result = turn(on, intensity)
      }
      
  }
    
    private func hasLamp(){
        let device = AVCaptureDevice.defaultDeviceWithMediaType
        return device.hasTorch && device.hasFlash
    }
    
    private func turn(on: Bool, intensity: Float){
        let device = AVCaptureDevice.defaultDeviceWithMediaType
        if !(device.hasTorch && device.hasFlash) return;
        
        device.lockForConfiguration()
        Float acceptedLevel =
            (level < AVCaptureMaxAvailableTorchLevel ?
             level : AVCaptureMaxAvailableTorchLevel);
        
        device.setTorchModeOnWithLevel(acceptedLevel)
        device.unlockForConfiguration()
    }
}
