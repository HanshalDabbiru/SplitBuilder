import SwiftUI

struct SplitList: View {
    @Binding var splits: [Split]
    @State private var isPresentingNewSplit = false
    @State var newSplit: Split = Split(name: "", dayList: [], theme: Theme.allCases.randomElement()!)
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var sharedSplitData: SharedData
    
    let saveAction: () -> Void
    
    var body: some View  {
        NavigationStack  {
            List($splits, editActions: .all) { $split in
                NavigationLink(destination: SplitView(split: $split, saveAction: {})) {
                    TextField("", text: $split.name)
                        .font(.largeTitle)
                        .padding()
                    
                }
                .listRowBackground(split.theme.mainColor)
            }
            .navigationTitle("Splits")
            .toolbar {
                ToolbarItem {
                    Button(action: {isPresentingNewSplit = true}) {
                        Image(systemName: "plus")
                    }
                    .alert("Enter split name", isPresented: $isPresentingNewSplit) {
                        TextField("Name", text: $newSplit.name)
                        Button("OK") {
                            add()
                        }
                    }
                }
            }

        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    func add() {
        var s = newSplit
        s.id = UUID()
        s.theme = Theme.allCases.randomElement()!
        splits.append(s)
    }
}

struct SplitList_Previews: PreviewProvider  {
    static var previews: some View  {
        SplitList(splits: .constant(SplitList.sampleData), saveAction: {})
    }
}

extension SplitList {
    static let sampleData: [Split] =  [
        Split(name: "PPL", dayList:
                [
                    Day(name: "Push", exercises:
                            [
                                Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .orange),
                                Exercise(name: "Dips", weight: 30, sets: 3, reps: 12, theme: .oxblood),
                                Exercise(name: "Chest Press", weight: 90, sets: 3, reps: 12, theme: .seafoam),
                                Exercise(name: "Cable Flies", weight: 30, sets: 3, reps: 12, theme: .sky)
                            ], theme: .periwinkle),
                    Day(name: "Pull", exercises:
                            [
                                Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .bubblegum),
                                Exercise(name: "Dips", weight: 185, sets: 3, reps: 12, theme: .lavender),
                                Exercise(name: "Chest Press", weight: 185, sets: 3, reps: 12, theme: .navy),
                                Exercise(name: "Cable Flies", weight: 185, sets: 3, reps: 12, theme: .tan)
                            ], theme: .buttercup)
                ], theme: Theme.magenta),
        Split(name: "Testing", dayList:
                [
                    Day(name: "Push", exercises:
                            [
                                Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .orange),
                                Exercise(name: "Dips", weight: 30, sets: 3, reps: 12, theme: .oxblood),
                                Exercise(name: "Chest Press", weight: 90, sets: 3, reps: 12, theme: .seafoam),
                                Exercise(name: "Cable Flies", weight: 30, sets: 3, reps: 12, theme: .sky)
                            ], theme: .periwinkle),
                    Day(name: "Pull", exercises:
                            [
                                Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .bubblegum),
                                Exercise(name: "Dips", weight: 185, sets: 3, reps: 12, theme: .lavender),
                                Exercise(name: "Chest Press", weight: 185, sets: 3, reps: 12, theme: .navy),
                                Exercise(name: "Cable Flies", weight: 185, sets: 3, reps: 12, theme: .tan)
                            ], theme: .buttercup)
                ], theme: Theme.orange)
    ]
}

