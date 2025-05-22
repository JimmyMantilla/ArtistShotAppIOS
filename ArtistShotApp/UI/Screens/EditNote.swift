import SwiftUI

struct EditNoteView: View {
    @Binding var isPresented: Bool
    @State var title: String
    @State var noteBody: String
    @State var tags: String
    var onSave: (_ title: String, _ body: String, _ tags: String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Edit Note")
                .font(.title2.bold())

            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)

            TextEditor(text: $noteBody)
                .frame(height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

            TextField("Tags (comma separated)", text: $tags)
                .textFieldStyle(.roundedBorder)

            HStack {
                Spacer()
                Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.gray)

                Button("Save") {
                    let tagArray = tags
                        .split(separator: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    onSave(title, noteBody, tags) 
                    isPresented = false
                }
                .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .padding()
    }
}
