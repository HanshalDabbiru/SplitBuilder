// Shows all the days that are in the split
import SwiftUI


struct SplitView: View {
    @State private var isPresentingNewDayView = false
    @Binding var split: Split
    @Environment(\.scenePhase) private var scenePhase
    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("splits.data")
    
    let saveAction: () -> Void
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    Section(header: HStack {
                        Spacer()
                        Text("Current Day").font(.title3)
                        Spacer()})
                    {
                        ForEach(1..<2) { value in
                            if(split.currentDay == -1) {
                                DayDetailCardView(day: Day.emptyDay)
                                    .listRowBackground(Day.emptyDay.theme.mainColor)
                            }
                            else {
                                NavigationLink(destination: DayView(day: $split.dayList[split.currentDay])) {
                                    DayDetailCardView(day: split.dayList[split.currentDay])
                                }
                                .listRowBackground(split.dayList[split.currentDay].theme.mainColor)
                            }
                        }
                        
                    }
                    Section(header: HStack{ Spacer(); Text("Full Split").font(.title3); Spacer() }) {
                        ForEach($split.dayList, editActions: .all) { $day in
                            NavigationLink(destination: EditDayView(day: $day)) {
                                DayCardView(day: $day)
                            }
                            .listRowBackground(day.theme.mainColor)
                        }
                    }

                }
                .navigationTitle(split.name)
                .toolbar {
                    ToolbarItem {
                        ShareLink("share split", item: fileURL)
                    }
                    /*
                    ToolbarItem {
                        Button(action: share) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    */
                    ToolbarItem {
                        Button(action: {isPresentingNewDayView = true}) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isPresentingNewDayView) {
                    NavigationStack {
                        NewDayView(split: $split, isPresentingNewDayView: $isPresentingNewDayView)
                    }
                }
            }
            
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView(split: .constant(Split.sampleData), saveAction: {} )
    }
}


/*     func share() {
 let encoder = JSONEncoder()
 do {
 let dataJSON = try encoder.encode(split)
 let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("split.data")
 try dataJSON.write(to: fileURL)
 
 let activityItems: [Any] = [fileURL]
 
 let av = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
 if let viewController = UIApplication.shared.windows.first?.rootViewController {
 av.popoverPresentationController?.sourceView = viewController.view
 viewController.present(av, animated: true, completion: nil)
 }
 }
 catch {
 print("Error occured")
 }
 }
*/


