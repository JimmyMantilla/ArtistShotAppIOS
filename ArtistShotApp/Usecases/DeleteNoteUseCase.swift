protocol DeleteNoteUseCase {
    func execute(note: Note) async throws
}

class DeleteNoteUseCaseImpl: DeleteNoteUseCase {
    private let localRepo: LocalNoteRepository

    init(localRepo: LocalNoteRepository) {
        self.localRepo = localRepo
    }

    func execute(note: Note) async throws {
        try await localRepo.delete(note: note)
    }
}
