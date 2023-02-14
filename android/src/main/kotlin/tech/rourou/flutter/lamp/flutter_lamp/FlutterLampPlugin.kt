package tech.rourou.flutter.lamp.flutter_lamp

import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.os.Build
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterLampPlugin */
class FlutterLampPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: android.content.Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "github.com/bigyao25/flutter_lamp")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "hasLamp") {
            var has = hasLamp()
            result.success(has)
        } else if (call.method == "turn") {
            var on = call.argument<Boolean>("on") ?: false
            turn(on)
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun hasLamp(): Boolean {
        return context.applicationContext.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
    }

    private val _registrar: Registrar? = null
    private val TAG = "FlashlightProvider"
    private var mCamera: android.hardware.Camera? = null

    //  private var parameters: android.hardware.Camera.Parameters? = null
    private var camManager: CameraManager? = null

    private fun turn(on: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            try {
                if (camManager == null) {
                    camManager = context
                        .getSystemService(android.content.Context.CAMERA_SERVICE) as CameraManager
                }
                if (camManager != null) {
                    var cameraId =
                        camManager!!.cameraIdList[0] // Usually front camera is at 0 position.
                    camManager!!.setTorchMode(cameraId, on)
//                    camManager!!.setTorchLevel(cameraId, 2)
                }
            } catch (e: Exception) {
                android.util.Log.e(TAG, e.toString())
            }
        } else {
            mCamera = android.hardware.Camera.open()
            if (mCamera != null) {
                var parameters = mCamera!!.getParameters()
                if (on) {
                    parameters.setFlashMode(android.hardware.Camera.Parameters.FLASH_MODE_TORCH)
                } else {
                    parameters.setFlashMode(android.hardware.Camera.Parameters.FLASH_MODE_OFF)
                }
                mCamera!!.setParameters(parameters)
                mCamera!!.startPreview()
            }
        }
    }
}
