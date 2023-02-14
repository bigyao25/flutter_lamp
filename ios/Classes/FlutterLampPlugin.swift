import Flutter
import UIKit
import AVFoundation

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
            let res = hasLamp()
            result(res)
        } else if method == "turn" {
            let on = (args?["on"] as! Bool?) ?? false
            let intensity = (args?["intensity"] as! Double?) ?? 0
            turn(on: on, intensity: Float(intensity))
        }
    }
    
    private func hasLamp() -> Bool {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device==nil { return false }
        return (device?.hasTorch ?? false) && (device?.hasFlash ?? false)
    }
    
    private func turn(on: Bool, intensity: Float) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device==nil { return }
        if !((device?.hasTorch ?? false) && (device?.hasFlash ?? false)) { return }
        
        var level = intensity
        if level<0 {level=0}
        if level>1 {level=1}
        
        do{
            try device?.lockForConfiguration()
            
            if on{
                try device?.setTorchModeOn(level: level)
                
            } else{
                device?.torchMode = .off
            }
            device?.unlockForConfiguration()
        } catch {}
    }
}
