import Foundation
import Combine
import Resolver

class NotesViewModel: ObservableObject {
    // MARK: - Login properties
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var loginFailed: Bool = false

    // MARK: - Notes properties
    @Published var notes: [Note] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies
    private let loginUseCase: LoginUseCase
    private let fetchNotesUseCase: FetchNotesUseCase
    private let fetchLocalNotesUseCase: FetchLocalNotesUseCase
    private let addNoteUseCase: AddNoteUseCase
    private let editNoteUseCase: EditNoteUseCase
    private let deleteNoteUseCase: DeleteNoteUseCase

    // MARK: - Init with DI
    init(
        loginUseCase: LoginUseCase = Resolver.resolve(),
        fetchNotesUseCase: FetchNotesUseCase = Resolver.resolve(),
        fetchLocalNotesUseCase: FetchLocalNotesUseCase = Resolver.resolve(),
        addNoteUseCase: AddNoteUseCase = Resolver.resolve(),
        editNoteUseCase: EditNoteUseCase = Resolver.resolve(),
        deleteNoteUseCase: DeleteNoteUseCase = Resolver.resolve()
    ) {
        self.loginUseCase = loginUseCase
        self.fetchNotesUseCase = fetchNotesUseCase
        self.fetchLocalNotesUseCase = fetchLocalNotesUseCase
        self.addNoteUseCase = addNoteUseCase
        self.editNoteUseCase = editNoteUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
    }

    // MARK: - Login
    func login() {
        if loginUseCase.execute(username: username, password: password) {
            isLoggedIn = true
            loginFailed = false

            Task {
                await loadNotes()
            }
        } else {
            loginFailed = true
        }
    }

    // MARK: - Load Notes
    @MainActor
    func loadNotes() async {
        isLoading = true
        errorMessage = nil

        let localNotes = fetchLocalNotesUseCase.execute()
        if !localNotes.isEmpty {
            self.notes = localNotes.sorted { $0.date > $1.date } // ⬅️ Sort descending
        } else {
            do {
                let fetchedNotes = try await fetchNotesUseCase.execute()
                self.notes = fetchedNotes.sorted { $0.date > $1.date } // ⬅️ Sort descending
            } catch {
                errorMessage = "Error loading notes: \(error.localizedDescription)"
            }
        }

        isLoading = false
    }

    // MARK: - Local Note Manipulation

    func addNote(_ note: Note) {
        Task {
            do {
                try await addNoteUseCase.execute(note: note)
                DispatchQueue.main.async {
                    self.notes.append(note)
                    self.notes.sort { $0.date > $1.date } // ⬅️ Maintain latest-first order
                }
            } catch {
                print("❌ Failed to add note: \(error)")
            }
        }
    }

    func updateNote(note: Note, title: String, body: String, tags: String) {
        let updatedNote = Note(
            id: note.id,
            serverId: note.serverId,
            title: title,
            bodyText: body,
            date: Date(),
            tags: tags
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        )

        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = updatedNote
        }

        Task {
            do {
                try await editNoteUseCase.execute(note: updatedNote)
            } catch {
                print("❌ Error updating note: \(error)")
            }
        }
    }

    func deleteNote(_ note: Note) {
        Task {
            do {
                // Primero borra de la lista en memoria
                await MainActor.run {
                    self.notes.removeAll { $0.id == note.id }
                }

                // Luego ejecuta el use case
                try await deleteNoteUseCase.execute(note: note)
            } catch {
                print("❌ Error deleting note: \(error)")
            }
        }
    }
}
