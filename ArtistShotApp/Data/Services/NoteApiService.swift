import Foundation
import CoreData
import Combine

protocol NotesApiService {
    func fetchNotes() async throws -> [NoteDTO]
}

class NotesApiServiceImpl: NotesApiService {
    func fetchNotes() async throws -> [NoteDTO] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode([NoteDTO].self, from: data)
        } catch {
            print("Network error:", error)
            throw error
        }
    }
}
