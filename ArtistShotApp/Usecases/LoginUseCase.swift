import Foundation

struct LoginUseCase {
    func execute(username: String, password: String) -> Bool {
        return username == "artist1" && password == "artist123"
    }
}
