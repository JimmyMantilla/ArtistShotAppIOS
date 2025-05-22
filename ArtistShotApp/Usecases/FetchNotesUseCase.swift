// FetchNotesUseCase.swift
import Foundation

protocol FetchNotesUseCase {
    func execute() async throws -> [Note]
}

class FetchNotesUseCaseImpl: FetchNotesUseCase {
    private let remoteRepo: NoteRepository
    private let localRepo: LocalNoteRepository

    init(remoteRepo: NoteRepository, localRepo: LocalNoteRepository) {
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }
    
    func execute() async throws -> [Note] {
        let notes = try await remoteRepo.fetchNotes()
        localRepo.saveNotes(notes) // Guarda en Core Data
        return notes
    }
}
