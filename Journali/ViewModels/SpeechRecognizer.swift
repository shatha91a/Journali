
import SwiftUI
@preconcurrency import Speech
import AVFoundation

// MARK: - Speech Request Box

private final class SpeechRequestBox: @unchecked Sendable {

    let request: SFSpeechAudioBufferRecognitionRequest

    init(request: SFSpeechAudioBufferRecognitionRequest) {
        self.request = request
    }

    func append(_ buffer: AVAudioPCMBuffer) {
        request.append(buffer)
    }
}

// MARK: - Audio Buffer Box

// MARK: - Audio Buffer Box

private final class AudioBufferBox: @unchecked Sendable {

    nonisolated(unsafe) let buffer: AVAudioPCMBuffer

    nonisolated init(buffer: AVAudioPCMBuffer) {
        self.buffer = buffer
    }
}

// MARK: - Speech Recognizer

@MainActor
@Observable
final class SpeechRecognizer {

    var recognizedText = ""
    var isRecording = false

    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isTapInstalled = false

    // MARK: - Start Recording

    func startRecording() {

        let languageCode = Locale.preferredLanguages.first ?? "en-US"

        let locale = languageCode.hasPrefix("ar")
            ? Locale(identifier: "ar-SA")
            : Locale(identifier: "en-US")

        SFSpeechRecognizer.requestAuthorization { [weak self] status in

            Task { @MainActor in

                guard let self, status == .authorized else { return }

                guard let recognizer = SFSpeechRecognizer(locale: locale),
                      recognizer.isAvailable else {
                    return
                }

                AVAudioApplication.requestRecordPermission { granted in

                    Task { @MainActor in

                        guard granted else { return }

                        self.beginRecording(using: recognizer)
                    }
                }
            }
        }
    }

    // MARK: - Begin Recording

    private func beginRecording(using recognizer: SFSpeechRecognizer) {

        stopRecording()
        recognizedText = ""

        let request = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest = request
        request.shouldReportPartialResults = true

        let requestBox = SpeechRequestBox(request: request)
        let inputNode = audioEngine.inputNode

        do {

            try inputNode.installAudioTap(
                onBus: 0,
                bufferSize: 8192,
                format: nil
            ) { buffer, _ in

                let audioBuffer = AVAudioPCMBuffer(copying: buffer)
                let bufferBox = AudioBufferBox(buffer: audioBuffer)

                Task { @MainActor in
                    requestBox.append(bufferBox.buffer)
                }
            }

            isTapInstalled = true

            recognitionTask = recognizer.recognitionTask(
                with: request
            ) { [weak self] result, error in

                Task { @MainActor in

                    guard let self else { return }

                    if let result {
                        self.recognizedText =
                            result.bestTranscription.formattedString
                    }

                    if error != nil || result?.isFinal == true {
                        self.stopRecording()
                    }
                }
            }

            audioEngine.prepare()
            try audioEngine.start()

            isRecording = true

        } catch {

            stopRecording()
            print("Recording failed: \(error)")
        }
    }

    // MARK: - Stop Recording

    func stopRecording() {

        if audioEngine.isRunning {
            audioEngine.stop()
        }

        if isTapInstalled {
            audioEngine.inputNode.removeTap(onBus: 0)
            isTapInstalled = false
        }

        recognitionRequest?.endAudio()
        recognitionTask?.cancel()

        recognitionRequest = nil
        recognitionTask = nil

        isRecording = false
    }
}
