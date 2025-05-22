

import Foundation

extension NoteDTO {
    func toNote() -> Note {
        return Note(
            id: UUID(),                     // Generate new UUID for local storage
            serverId: self.id,              // Preserve the server ID
            title: self.title,
            bodyText: self.body,
            date: Date(),                   // Or use date from DTO if available
            tags: []   
        )
    }
}
