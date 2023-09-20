import SwiftUI

@MainActor
class SplitStore: ObservableObject {
    @Published var split: [Split] = []
    static var file: URL? = fileURL()
    

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
                let split = try JSONDecoder().decode([Split].self, from: data)
                return split
            }
            let split = try await task.value
            self.split = split
    }
    
    func save(split: [Split]) async throws {
            let task = Task {
                let data = try JSONEncoder().encode(split)
                let outfile = Self.fileURL()
                SplitStore.file = outfile
                try data.write(to: outfile)
            }
            _ = try await task.value
        }
}
