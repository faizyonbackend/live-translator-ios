import SwiftUI
import Translation
import Speech

enum ActiveSpeaker {
    case none
    case personA
    case personB
}

struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var speechSynthesizer = SpeechSynthesizer()

    // Languages
    @State private var langA: Language = Language.supportedLanguages[0] // English
    @State private var langB: Language = Language.supportedLanguages[1] // Spanish

    // Transcripts and Translations
    @State private var personASpokenText: String = ""
    @State private var personATranslatedText: String = ""

    @State private var personBSpokenText: String = ""
    @State private var personBTranslatedText: String = ""

    // Translation configuration for Apple Translation Framework
    @State private var translationConfig: TranslationSession.Configuration?
    @State private var pendingTranslationSource: ActiveSpeaker = .none

    @State private var activeSpeaker: ActiveSpeaker = .none
    @State private var isAutoSpeakEnabled: Bool = true
    @State private var isFaceToFaceMode: Bool = false
    @State private var showLangAPicker: Bool = false
    @State private var showLangBPicker: Bool = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Card: Person A
                speakerCard(
                    speaker: .personA,
                    language: langA,
                    spokenText: personASpokenText,
                    translatedText: personATranslatedText,
                    targetLanguage: langB,
                    isFlipped: isFaceToFaceMode,
                    onSelectLanguage: { showLangAPicker = true }
                )

                // Center Control Divider
                centerControlBar

                // Bottom Card: Person B
                speakerCard(
                    speaker: .personB,
                    language: langB,
                    spokenText: personBSpokenText,
                    translatedText: personBTranslatedText,
                    targetLanguage: langA,
                    isFlipped: false,
                    onSelectLanguage: { showLangBPicker = true }
                )
            }
        }
        .translationTask(translationConfig) { session in
            await performTranslation(with: session)
        }
        .sheet(isPresented: $showLangAPicker) {
            LanguagePickerView(selectedLanguage: $langA)
        }
        .sheet(isPresented: $showLangBPicker) {
            LanguagePickerView(selectedLanguage: $langB)
        }
        .task {
            _ = await speechRecognizer.requestPermissions()
        }
    }

    // MARK: - Center Control Bar
    private var centerControlBar: some View {
        HStack(spacing: 16) {
            // Swap Languages Button
            Button {
                withAnimation(.spring) {
                    let temp = langA
                    langA = langB
                    langB = temp

                    let tempSpoken = personASpokenText
                    let tempTrans = personATranslatedText
                    personASpokenText = personBSpokenText
                    personATranslatedText = personBTranslatedText
                    personBSpokenText = tempSpoken
                    personBTranslatedText = tempTrans
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }

            // Offline & Privacy Badge
            HStack(spacing: 6) {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(.green)
                    .font(.caption)
                Text("100% Offline & Private")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)

            // Face-to-Face Flip Mode Toggle
            Button {
                withAnimation(.spring) {
                    isFaceToFaceMode.toggle()
                }
            } label: {
                Image(systemName: isFaceToFaceMode ? "arrow.counterclockwise.circle.fill" : "person.2.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isFaceToFaceMode ? .blue : .secondary)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }

            // Auto-speak Toggle
            Button {
                isAutoSpeakEnabled.toggle()
            } label: {
                Image(systemName: isAutoSpeakEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isAutoSpeakEnabled ? .blue : .secondary)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
        .zIndex(1)
    }

    // MARK: - Speaker Card
    @ViewBuilder
    private func speakerCard(
        speaker: ActiveSpeaker,
        language: Language,
        spokenText: String,
        translatedText: String,
        targetLanguage: Language,
        isFlipped: Bool,
        onSelectLanguage: @escaping () -> Void
    ) -> some View {
        let isCurrentSpeakerRecording = (activeSpeaker == speaker && speechRecognizer.isRecording)

        VStack(spacing: 12) {
            // Header: Flag, Name, and Language Picker
            HStack {
                Button(action: onSelectLanguage) {
                    HStack(spacing: 8) {
                        Text(language.flag)
                            .font(.title3)
                        Text(language.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .cornerRadius(10)
                }

                Spacer()

                if !translatedText.isEmpty {
                    Button {
                        speechSynthesizer.speak(text: translatedText, voiceCode: targetLanguage.ttsVoiceCode)
                    } label: {
                        Image(systemName: speechSynthesizer.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                            .foregroundColor(.blue)
                            .padding(8)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .clipShape(Circle())
                    }
                }
            }

            // Conversation Display Box
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if spokenText.isEmpty && !isCurrentSpeakerRecording {
                        Text("Tap the microphone and speak in \(language.name)...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 24)
                    } else {
                        // Original Transcript
                        if isCurrentSpeakerRecording {
                            Text(speechRecognizer.transcript.isEmpty ? "Listening..." : speechRecognizer.transcript)
                                .font(.body)
                                .foregroundColor(.primary)
                                .italic()
                        } else if !spokenText.isEmpty {
                            Text(spokenText)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        // Translated Output
                        if !translatedText.isEmpty {
                            Divider()
                            Text(translatedText)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)

            // Mic Button
            Button {
                toggleRecording(for: speaker, language: language, targetLanguage: targetLanguage)
            } label: {
                ZStack {
                    if isCurrentSpeakerRecording {
                        Circle()
                            .stroke(Color.red.opacity(0.3), lineWidth: 8)
                            .frame(width: 74, height: 74)
                            .scaleEffect(1.15)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isCurrentSpeakerRecording)
                    }

                    Circle()
                        .fill(isCurrentSpeakerRecording ? Color.red : Color.blue)
                        .frame(width: 60, height: 60)

                    Image(systemName: isCurrentSpeakerRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .rotationEffect(isFlipped ? .degrees(180) : .degrees(0))
    }

    // MARK: - Actions & Translation Handling
    private func toggleRecording(for speaker: ActiveSpeaker, language: Language, targetLanguage: Language) {
        if activeSpeaker == speaker && speechRecognizer.isRecording {
            // Stop recording
            speechRecognizer.stopRecording()
            triggerTranslation(for: speaker, sourceLang: language, targetLang: targetLanguage)
        } else {
            // Start recording
            activeSpeaker = speaker
            speechRecognizer.startRecording(localeIdentifier: language.speechLocale) { finalTranscript in
                Task { @MainActor in
                    triggerTranslation(for: speaker, sourceLang: language, targetLang: targetLanguage)
                }
            }
        }
    }

    private func triggerTranslation(for speaker: ActiveSpeaker, sourceLang: Language, targetLang: Language) {
        let transcript = speechRecognizer.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !transcript.isEmpty else { return }

        if speaker == .personA {
            personASpokenText = transcript
        } else {
            personBSpokenText = transcript
        }

        pendingTranslationSource = speaker

        // Configure on-device translation session
        let sourceLocale = Locale.Language(identifier: sourceLang.id)
        let targetLocale = Locale.Language(identifier: targetLang.id)

        if translationConfig == nil {
            translationConfig = .init(source: sourceLocale, target: targetLocale)
        } else {
            translationConfig?.invalidate()
        }
    }

    private func performTranslation(with session: TranslationSession) async {
        let textToTranslate = (pendingTranslationSource == .personA) ? personASpokenText : personBSpokenText
        guard !textToTranslate.isEmpty else { return }

        do {
            // Offline on-device translation
            let response = try await session.translate(textToTranslate)
            let result = response.targetText

            if pendingTranslationSource == .personA {
                personATranslatedText = result
                if isAutoSpeakEnabled {
                    speechSynthesizer.speak(text: result, voiceCode: langB.ttsVoiceCode)
                }
            } else {
                personBTranslatedText = result
                if isAutoSpeakEnabled {
                    speechSynthesizer.speak(text: result, voiceCode: langA.ttsVoiceCode)
                }
            }
        } catch {
            print("Translation error: \(error.localizedDescription)")
        }

        activeSpeaker = .none
    }
}
