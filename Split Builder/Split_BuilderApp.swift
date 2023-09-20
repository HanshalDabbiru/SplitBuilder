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
                        print(split.split)
                        try await split.load()
                        print(split.split)
                    } catch {
                        print(error)
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
