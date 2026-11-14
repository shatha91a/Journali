
import SwiftUI

struct SearchBarView: View {

    @Bindable var viewModel: JournalViewModel

    @State private var speechRecognizer = SpeechRecognizer()

    var body: some View {

        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColors.secondaryText)

            TextField("Search", text: $viewModel.searchText)
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.primaryText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            Spacer()

            Button {
                if speechRecognizer.isRecording {
                    speechRecognizer.stopRecording()
                } else {
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

        .onChange(of: speechRecognizer.recognizedText) {
            _, newValue in

            viewModel.searchText = newValue
        }

        .onDisappear {
            speechRecognizer.stopRecording()
        }
    }
}
