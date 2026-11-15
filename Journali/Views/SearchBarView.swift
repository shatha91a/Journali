
import SwiftUI

struct SearchBarView: View {

    @Bindable var viewModel: JournalViewModel
    let isJournalFormPresented: Bool
    @State private var speechRecognizer = SpeechRecognizer()

    @FocusState private var isSearchFocused: Bool

    var body: some View {

        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColors.secondaryText)

            TextField("Search", text: $viewModel.searchText)
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.primaryText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isSearchFocused)
                .submitLabel(.search)
                .onSubmit {
                    isSearchFocused = false
                }
            Spacer()

            Button {

                if speechRecognizer.isRecording {

                    speechRecognizer.stopRecording()

                } else {

                    // Hide keyboard before recording
                    isSearchFocused = false

                    speechRecognizer.startRecording()
                }

            } label: {

                Image(
                    systemName: speechRecognizer.isRecording
                    ? "waveform"
                    : "mic"
                )
                .foregroundStyle(
                    speechRecognizer.isRecording
                    ? AppColors.primary
                    : AppColors.secondaryText
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, AppSpacing.medium)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(AppColors.surface, in: Capsule())

        // Update search text from speech recognition
        .onChange(of: speechRecognizer.recognizedText) {
            _, newValue in

            viewModel.searchText = newValue
        }
        .onChange(of: isJournalFormPresented) { _, isPresented in
            if isPresented {
                speechRecognizer.stopRecording()
                isSearchFocused = false
            }
        }

        // Stop recording when leaving the screen
        .onDisappear {
            speechRecognizer.stopRecording()
        }
    }
}
