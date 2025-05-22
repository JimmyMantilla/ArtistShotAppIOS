import Foundation

protocol EditNoteUseCase {
    func execute(note: Note) async throws
}

class EditNoteUseCaseImpl: EditNoteUseCase {
    private let repository: LocalNoteRepository

    init(repository: LocalNoteRepository) {
        self.repository = repository
    }

    func execute(note: Note) async throws {
        try await repository.update(note: note)
    }
}
