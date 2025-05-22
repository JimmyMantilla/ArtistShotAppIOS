import Foundation

protocol AddNoteRepository {
    func addNote(_ note: Note) async throws
}

class AddNoteRepositoryImpl: AddNoteRepository {
    private let localRepository: LocalNoteRepository

    init(localRepository: LocalNoteRepository) {
        self.localRepository = localRepository
    }

    func addNote(_ note: Note) {
        localRepository.saveNotes([note])
    }
}
