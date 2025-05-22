import Foundation
import CoreData
import SwiftUI


protocol LocalNoteRepository: AddNoteRepository {
    func saveNotes(_ notes: [Note])
    func fetchNotes() -> [Note]
    func update(note: Note) async throws
    func delete(note: Note) async throws
}

class LocalNoteRepositoryImpl: LocalNoteRepository {
    private let context = CoreDataManager.shared.context
    
    func saveNotes(_ notes: [Note]) {
        // Save new ones
        notes.forEach { note in
            let entity = NoteEntity(context: context)
            entity.id = note.id  // Make sure NoteEntity.id is UUID type
            entity.title = note.title
            entity.bodytext = note.bodyText
            entity.date = note.date
            entity.tags = try? JSONEncoder().encode(note.tags)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save notes: \(error)")
        }
    }
    
    func fetchNotes() -> [Note] {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { entity in
                guard let id = entity.id,
                      let title = entity.title,
                      let bodyText = entity.bodytext,
                      let date = entity.date,
                      let tagsData = entity.tags,
                      let tags = try? JSONDecoder().decode([String].self, from: tagsData)
                else {
                    print("Failed to decode one or more notes")
                    return nil
                }
                
                return Note(
                    id: id,
                    serverId: nil, // <- agregar esto soluciona el error
                    title: title,
                    bodyText: bodyText,
                    date: date,
                    tags: tags
                )
            }
        } catch {
            print("Failed to fetch notes: \(error)")
            return []
        }
    }
    

    
    func addNote(_ note: Note) async throws {
        let entity = NoteEntity(context: context)
        entity.id = note.id
        entity.title = note.title
        entity.bodytext = note.bodyText
        entity.date = note.date
        entity.tags = try? JSONEncoder().encode(note.tags)
        
        try context.save()
    }
    
    func update(note: Note) async throws {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg) // ✅ Fix UUID
        
        let results = try context.fetch(request)
        
        guard let entityToUpdate = results.first else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Note not found"])
        }
        
        entityToUpdate.title = note.title
        entityToUpdate.bodytext = note.bodyText
        entityToUpdate.date = note.date
        entityToUpdate.tags = try? JSONEncoder().encode(note.tags)
        
        try context.save()
    }
    func delete(note: Note) async throws {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)

        do {
            let results = try context.fetch(request)
            guard let entityToDelete = results.first else {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Note not found"])
            }

            context.delete(entityToDelete)
            try context.save()
        } catch {
            throw error
        }
    }
}
