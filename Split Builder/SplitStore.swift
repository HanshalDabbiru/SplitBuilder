import SwiftUI

@MainActor
class SplitStore: ObservableObject {
    @Published var split: [Split] = []
    

     private static func fileURL() -> URL {
        try! FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
        .appendingPathComponent("splits.data")
    }
    
    func load() async throws {
            let task = Task<[Split], Error> {
                let fileURL = Self.fileURL()
                guard let data = try? Data(contentsOf: fileURL) else {
                    return []
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Failed to convert data to a UTF-8 string.")
                }
                let split = try JSONDecoder().decode([Split].self, from: data)
                return split
            }
            let split = try await task.value
            self.split = split
    }
    
    func save(split: [Split]) async throws {
            let task = Task {
                let data = try JSONEncoder().encode(split)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Failed to convert data to a UTF-8 string.")
                }
                let outfile = Self.fileURL()
                try data.write(to: outfile)
            }
            _ = try await task.value
        }
}
