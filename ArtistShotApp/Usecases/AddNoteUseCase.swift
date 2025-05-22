// AddNoteUseCase.swift
import Foundation

class AddNoteUseCase {
    private let repository: AddNoteRepository

    init(repository: AddNoteRepository) {
        self.repository = repository
    }

    func execute(note: Note) async throws {
        try await repository.addNote(note)
    }
}
