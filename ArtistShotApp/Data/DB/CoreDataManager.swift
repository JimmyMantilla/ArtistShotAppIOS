
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "NotesModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
