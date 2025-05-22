
import Foundation

protocol NoteRepository {
    func fetchNotes() async throws -> [Note]
}

class NoteRepositoryImpl: NoteRepository {
    private let apiService: NotesApiService
    
    init(apiService: NotesApiService) {
        self.apiService = apiService
    }
    
    func testInternetConnection() async -> Bool {
        guard let url = URL(string: "https://www.google.com") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 Internet Test Status Code: \(httpResponse.statusCode)")
                return httpResponse.statusCode == 200
            }
        } catch {
            print("❌ Internet connection test failed: \(error.localizedDescription)")
        }

        return false
    }
    
    func fetchNotes() async throws -> [Note] {
        print("📦 Llamando a apiService.fetchNotes() desde el repositorio")
        
        let dtos = try await apiService.fetchNotes()
        
        print("📝 Obtuvo \(dtos.count) DTOs desde la API")
        
        let notes = dtos.map { $0.toNote() }
        print("📄 Convertidos a \(notes.count) Notes")
        
        return notes
    }
}
