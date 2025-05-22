import Foundation

struct NoteDTO: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
