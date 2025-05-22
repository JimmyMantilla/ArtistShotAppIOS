import SwiftUI

struct NoteItemView: View {
    let title: String
    let date: Date
    let bodyText: String
    let tags: [String]
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Título
            Text(title)
                .font(.headline)
                .bold()
                .lineLimit(2)

            // Fecha
            Text(formattedDate(date))
                .font(.subheadline)
                .foregroundColor(.gray)

            // Cuerpo
            Text(bodyText)
                .font(.body)
                .lineLimit(2)

            // Tags en LazyHStack
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        TagItemView(tag: tag)
                    }
                }
            }

            // Botones de acción
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
