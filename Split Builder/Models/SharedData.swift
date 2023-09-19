import SwiftUI
import Combine

class SharedData: ObservableObject {
    @Published var sharedSplit: Split?
    
    func handleData(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            var split = try decoder.decode(Split.self, from: data)
            split.id = UUID()
            sharedSplit = split
        }
        catch {
            print(error)
        }
    }
}
