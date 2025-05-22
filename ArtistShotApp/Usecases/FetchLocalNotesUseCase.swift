protocol FetchLocalNotesUseCase {
    func execute() -> [Note]
}

class FetchLocalNotesUseCaseImpl: FetchLocalNotesUseCase {
    private let localRepo: LocalNoteRepository

    init(localRepo: LocalNoteRepository) {
        self.localRepo = localRepo
    }

    func execute() -> [Note] {
        localRepo.fetchNotes()
    }
}
