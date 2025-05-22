import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        // Servicios API
        register { NotesApiServiceImpl() as NotesApiService }

        // Repositorios
        register { LocalNoteRepositoryImpl() }
            .implements(LocalNoteRepository.self)
            .implements(AddNoteRepository.self)

        register { NoteRepositoryImpl(apiService: resolve()) as NoteRepository }

        // Use Cases
        register { FetchNotesUseCaseImpl(remoteRepo: resolve(), localRepo: resolve()) as FetchNotesUseCase }

        register { FetchLocalNotesUseCaseImpl(localRepo: resolve()) as FetchLocalNotesUseCase }

        register { AddNoteUseCase(repository: resolve()) } // Ahora resolverá correctamente
        
        register { EditNoteUseCaseImpl(repository: resolve()) as EditNoteUseCase }
        
        register { DeleteNoteUseCaseImpl(localRepo: resolve()) as DeleteNoteUseCase }

        // ViewModels
        register { NotesViewModel(fetchNotesUseCase: resolve()) }

        register { LoginUseCase() }

        // CoreData Manager
        register { CoreDataManager.shared }
    }
}
