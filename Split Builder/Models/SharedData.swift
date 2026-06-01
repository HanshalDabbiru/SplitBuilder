import SwiftUI

class SharedData: ObservableObject {
    @Published var sharedSplit: Split?

    func handleData(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            var split = try JSONDecoder().decode(Split.self, from: data)
            split.id = UUID()
            sharedSplit = split
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
