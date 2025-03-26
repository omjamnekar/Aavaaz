import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    var audioRecorder: AVAudioRecorder?
    var audioFilename: URL?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "micwave/audio", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { (call, result) in
            switch call.method {
                case "startRecording":
                    self.startRecording()
                    result("Recording started")
                case "stopRecording":
                    let filePath = self.stopRecording()
                    result(filePath)
                default:
                    result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playAndRecord, mode: .default)
        try? audioSession.setActive(true)

        let tempDir = FileManager.default.temporaryDirectory
        audioFilename = tempDir.appendingPathComponent("recording.m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        audioRecorder = try? AVAudioRecorder(url: audioFilename!, settings: settings)
        audioRecorder?.record()
    }

    func stopRecording() -> String {
        audioRecorder?.stop()
        return audioFilename?.path ?? ""
    }
}
