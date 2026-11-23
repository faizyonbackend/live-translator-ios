import Foundation

struct Language: Identifiable, Hashable {
    let id: String           // e.g., "en"
    let name: String         // e.g., "English"
    let flag: String         // e.g., "🇺🇸"
    let speechLocale: String // e.g., "en-US"
    let ttsVoiceCode: String // e.g., "en-US"

    // Supported offline languages in Apple's Translation Framework
    static let supportedLanguages: [Language] = [
        Language(id: "en", name: "English", flag: "🇺🇸", speechLocale: "en-US", ttsVoiceCode: "en-US"),
        Language(id: "es", name: "Spanish", flag: "🇪🇸", speechLocale: "es-ES", ttsVoiceCode: "es-ES"),
        Language(id: "fr", name: "French", flag: "🇫🇷", speechLocale: "fr-FR", ttsVoiceCode: "fr-FR"),
        Language(id: "de", name: "German", flag: "🇩🇪", speechLocale: "de-DE", ttsVoiceCode: "de-DE"),
        Language(id: "it", name: "Italian", flag: "🇮🇹", speechLocale: "it-IT", ttsVoiceCode: "it-IT"),
        Language(id: "ja", name: "Japanese", flag: "🇯🇵", speechLocale: "ja-JP", ttsVoiceCode: "ja-JP"),
        Language(id: "ko", name: "Korean", flag: "🇰🇷", speechLocale: "ko-KR", ttsVoiceCode: "ko-KR"),
        Language(id: "zh-Hans", name: "Chinese (Simplified)", flag: "🇨🇳", speechLocale: "zh-CN", ttsVoiceCode: "zh-CN"),
        Language(id: "pt", name: "Portuguese", flag: "🇧🇷", speechLocale: "pt-BR", ttsVoiceCode: "pt-BR"),
        Language(id: "hi", name: "Hindi", flag: "🇮🇳", speechLocale: "hi-IN", ttsVoiceCode: "hi-IN"),
        Language(id: "ar", name: "Arabic", flag: "🇸🇦", speechLocale: "ar-SA", ttsVoiceCode: "ar-SA"),
        Language(id: "ru", name: "Russian", flag: "🇷🇺", speechLocale: "ru-RU", ttsVoiceCode: "ru-RU")
    ]
}
