import SwiftUI
import Combine

class SharedData: ObservableObject {
    @Published var sharedSplit: Split?
    
    func handleData(url: URL) {
        do {
            let data: Data? = try Data(contentsOf: url)
            //var d: String? = String(data: data, encoding: .utf8)
            //var e = d!
            let unwrapped: Data = data!
            let decoder = JSONDecoder()
            let s: String = String(data: unwrapped, encoding: .utf8)!
            var split = try decoder.decode(Split.self, from: s.data(using: .utf8)!)
            split.id = UUID()
            sharedSplit = split
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}
