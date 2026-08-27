import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let deviceEmojiPlugin = DeviceEmojiPickerPlugin()
  private let screenCapturePlugin = ScreenCapturePlugin()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let messenger = engineBridge.applicationRegistrar.messenger()
    deviceEmojiPlugin.attach(to: messenger)
    screenCapturePlugin.attach(to: messenger)
  }
}

/// Reports screenshots. iOS cannot fully block them the way Android can.
final class ScreenCapturePlugin: NSObject {
  private var channel: FlutterMethodChannel?

  func attach(to messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "messanger_ax/screen_capture",
      binaryMessenger: messenger
    )
    self.channel = channel
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "setBlocked":
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didTakeScreenshot),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )
  }

  @objc private func didTakeScreenshot() {
    channel?.invokeMethod("screenshotTaken", arguments: nil)
  }
}

/// Opens the device emoji keyboard and forwards picked glyphs to Flutter.
final class DeviceEmojiPickerPlugin: NSObject, UITextFieldDelegate {
  private var channel: FlutterMethodChannel?
  private lazy var emojiField: EmojiTextField = {
    let field = EmojiTextField()
    field.delegate = self
    field.autocorrectionType = .no
    field.spellCheckingType = .no
    field.tintColor = .clear
    field.textColor = .clear
    field.backgroundColor = .clear
    field.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    field.alpha = 0.02
    return field
  }()

  func attach(to messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "messanger_ax/device_emoji",
      binaryMessenger: messenger
    )
    self.channel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(FlutterError(code: "unavailable", message: nil, details: nil))
        return
      }
      switch call.method {
      case "show":
        result(self.show())
      case "hide":
        self.hide()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func show() -> Bool {
    guard let window = Self.keyWindow else { return false }
    if emojiField.superview == nil {
      window.addSubview(emojiField)
    }
    return emojiField.becomeFirstResponder()
  }

  private func hide() {
    emojiField.resignFirstResponder()
    emojiField.removeFromSuperview()
  }

  private static var keyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first(where: \.isKeyWindow)
  }

  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    if !string.isEmpty {
      channel?.invokeMethod("emojiPicked", arguments: string)
    }
    return false
  }
}

private final class EmojiTextField: UITextField {
  override var textInputContextIdentifier: String? { "messanger_ax.emoji" }

  override var textInputMode: UITextInputMode? {
    UITextInputMode.activeInputModes.first { $0.primaryLanguage == "emoji" }
  }
}
