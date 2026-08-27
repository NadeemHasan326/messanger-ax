package com.example.messanger_ax

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private lateinit var screenCapturePlugin: ScreenCapturePlugin

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                DeviceEmojiPickerView.viewType,
                DeviceEmojiPickerFactory(messenger),
            )
        screenCapturePlugin = ScreenCapturePlugin(this).also { it.attach(messenger) }
    }
}
