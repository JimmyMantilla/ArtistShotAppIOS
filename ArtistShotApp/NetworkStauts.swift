// First, add this to check network status
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isConnected = false
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print("📶 Network status:", path.status)
        }
        monitor.start(queue: queue)
    }
    
    func checkConnection() -> Bool {
        var result = false
        queue.sync {
            result = isConnected
        }
        return result
    }
}
