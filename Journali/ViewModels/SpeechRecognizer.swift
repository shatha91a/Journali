
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

    private var isStarting = false

    private let audioEngine = AVAudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isTapInstalled = false

    // MARK: - Start Recording
    func startRecording() {

        guard !isRecording && !isStarting else {
            return
        }

        isStarting = true
        recognizedText = ""

        let languageCode = Locale.preferredLanguages.first ?? "en-US"

        let locale = languageCode.hasPrefix("ar")
            ? Locale(identifier: "ar-SA")
            : Locale(identifier: "en-US")

        print("Speech language: \(locale.identifier)")
        print("Requesting speech recognition permission...")

        SFSpeechRecognizer.requestAuthorization { [weak self] status in

            Task { @MainActor in

                guard let self else { return }

                guard status == .authorized else {
                    print("Speech authorization failed: \(status)")
                    self.isStarting = false
                    return
                }

                guard let recognizer = SFSpeechRecognizer(locale: locale) else {
                    print("Could not create speech recognizer.")
                    self.isStarting = false
                    return
                }

                guard recognizer.isAvailable else {
                    print("Speech recognizer is currently unavailable.")
                    self.isStarting = false
                    return
                }

                print("Speech recognizer is available.")

                AVAudioApplication.requestRecordPermission { granted in

                    Task { @MainActor in

                        guard granted else {
                            print("Microphone permission denied.")
                            self.isStarting = false
                            return
                        }

                        print("Microphone permission granted.")

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
        isStarting = true

        print("Starting speech recognition...")

        do {

            // Configure audio session
            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: [.duckOthers]
            )

            try audioSession.setActive(true)

            print("Audio session activated.")
            print("Input sample rate: \(audioSession.sampleRate)")
            print("Input channels: \(audioSession.inputNumberOfChannels)")

            guard audioSession.inputNumberOfChannels > 0 else {
                print("No audio input available.")
                stopRecording()
                return
            }

            let request = SFSpeechAudioBufferRecognitionRequest()

            recognitionRequest = request
            request.shouldReportPartialResults = true

            let requestBox = SpeechRequestBox(request: request)
            let inputNode = audioEngine.inputNode

            // Install audio tap
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

            print("Audio tap installed.")

            // Start speech recognition task
            recognitionTask = recognizer.recognitionTask(
                with: request
            ) { [weak self] result, error in

                Task { @MainActor in

                    guard let self else { return }

                    if let result {

                        self.recognizedText =
                            result.bestTranscription.formattedString

                        print("Recognized text: \(self.recognizedText)")
                    }

                    if let error {

                        print(
                            "Speech Recognition Error: \(error.localizedDescription)"
                        )

                        print("Error details: \(error)")

                        self.stopRecording()
                        return
                    }

                    if result?.isFinal == true {

                        print("Recognition finished.")

                        self.stopRecording()
                    }
                }
            }

            // Start audio engine
            audioEngine.prepare()
            try audioEngine.start()

            isRecording = true
            isStarting = false

            print("Audio engine started successfully.")
            print("Recording is active.")

        } catch {

            print("Recording failed: \(error.localizedDescription)")
            print("Error details: \(error)")

            stopRecording()
        }
    }

    // MARK: - Stop Recording
    func stopRecording() {

        print("Stopping speech recognition...")

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
        isStarting = false

        do {

            try audioSession.setActive(
                false,
                options: .notifyOthersOnDeactivation
            )

            print("Audio session deactivated.")

        } catch {

            print("Audio session error: \(error.localizedDescription)")
        }
    }
}
