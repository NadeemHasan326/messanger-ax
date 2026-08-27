package com.example.messanger_ax

import android.app.Activity
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class ScreenCapturePlugin(private val activity: FlutterActivity) {
    private var channel: MethodChannel? = null
    private var captureCallback: Activity.ScreenCaptureCallback? = null

    fun attach(messenger: BinaryMessenger) {
        val channel = MethodChannel(messenger, CHANNEL)
        this.channel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setBlocked" -> {
                    val blocked = call.arguments as? Boolean ?: false
                    if (blocked) {
                        activity.window.setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE,
                        )
                    } else {
                        activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val callback = Activity.ScreenCaptureCallback {
                channel.invokeMethod("screenshotTaken", null)
            }
            captureCallback = callback
            activity.registerScreenCaptureCallback(activity.mainExecutor, callback)
        }
    }

    companion object {
        const val CHANNEL = "messanger_ax/screen_capture"
    }
}
