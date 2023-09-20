import SwiftUI
import Combine

class SharedData: ObservableObject {
    @Published var sharedSplit: Split?
    
    func handleData(url: URL) {
        do {
            var data: Data? = try Data(contentsOf: url)
            //var d: String? = String(data: data, encoding: .utf8)
            //var e = d!
            var unwrapped: Data = data!
            let decoder = JSONDecoder()
            var s: String = String(data: unwrapped, encoding: .utf8)!
            var split = try decoder.decode(Split.self, from: s.data(using: .utf8)!)
            split.id = UUID()
            sharedSplit = split
        }
        catch {
            print(error)
        }
    }
}
