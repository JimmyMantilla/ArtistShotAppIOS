

import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id: UUID          // For CoreData compatibility
    let serverId: Int?    // For API/DTO compatibility (optional)
    let title: String
    let bodyText: String
    let date: Date
    let tags: [String]
}
