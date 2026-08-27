package com.example.messanger_ax

import android.content.Context
import android.view.View
import androidx.emoji2.emojipicker.EmojiPickerView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class DeviceEmojiPickerFactory(
    private val messenger: BinaryMessenger,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return DeviceEmojiPickerView(context, messenger)
    }
}

class DeviceEmojiPickerView(
    context: Context,
    messenger: BinaryMessenger,
) : PlatformView {
    private val channel = MethodChannel(messenger, DeviceEmojiPickerView.channelName)
    private val picker = EmojiPickerView(context).apply {
        setOnEmojiPickedListener { item ->
            channel.invokeMethod("emojiPicked", item.emoji)
        }
    }

    override fun getView(): View = picker

    override fun dispose() {}

    companion object {
        const val channelName = "messanger_ax/device_emoji"
        const val viewType = "messanger_ax/device_emoji_picker"
    }
}
