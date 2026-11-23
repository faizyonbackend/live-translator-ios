import SwiftUI

struct LanguagePickerView: View {
    @Binding var selectedLanguage: Language
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(Language.supportedLanguages) { lang in
                Button {
                    selectedLanguage = lang
                    dismiss()
                } label: {
                    HStack {
                        Text(lang.flag)
                            .font(.title2)
                        Text(lang.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        if lang.id == selectedLanguage.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
