import SwiftUI

@main
struct Split_BuilderApp: App {
    @StateObject private var split = SplitStore()
    @StateObject private var sharedSplit = SharedData()
    
    var body: some Scene {
        WindowGroup {
                SplitList(splits: $split.split) {
                    Task {
                        do {
                            try await split.save(split: split.split)
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                .task {
                    do {
                        try await split.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                .environmentObject(sharedSplit)
                .onOpenURL { url in
                    sharedSplit.handleData(url: url)
                    split.split.append(sharedSplit.sharedSplit!)
                    sharedSplit.sharedSplit = nil
                }
        }
    }
}
