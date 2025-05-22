
import SwiftUI

struct AddNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var tagInput: String = ""
    @State private var tags: [String] = []
    
    var onSave: ((Note) -> Void)? // Callback para devolver la nota creada
    
    var body: some View {
        VStack(spacing: 16) {
            // Cancel button
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .frame(width: 160, height: 40)
                        .background(Color(hex: "#E4E7FB"))
                        .cornerRadius(20)
                }
            }
            
            // Back arrow
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }
            
            // Main card
            VStack(alignment: .leading, spacing: 16) {
                TextField("Title", text: $title)
                    .padding()
                    .background(Color(hex: "#E4E7FB"))
                    .cornerRadius(8)
                
                TextEditor(text: $bodyText)
                    .frame(height: 150)
                    .padding()
                    .background(Color(hex: "#E4E7FB"))
                    .cornerRadius(8)
                
                Text("Tags")
                    .font(.headline)
                
                HStack {
                    TextField("Add tag", text: $tagInput)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Button(action: {
                        if !tagInput.isEmpty {
                            tags.append(tagInput)
                            tagInput = ""
                        }
                    }) {
                        Text("Add")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                
                // Optional: Display added tags
                if !tags.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(hex: "#E4E7FB"))
            .cornerRadius(20)
            
            // Save Note button
            Button(action: {
                let newNote = Note(
                    id: UUID(),
                    serverId: nil,  // You can pass nil since it's optional
                    title: title,
                    bodyText: bodyText,
                    date: Date(),
                    tags: tags
                )
                onSave?(newNote)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Note")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty || bodyText.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(20)
            }
            .disabled(title.isEmpty || bodyText.isEmpty)
            .padding(.top)
            
            Spacer()
        }
        .padding()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}
