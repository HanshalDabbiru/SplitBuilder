// Shows all the days that are in the split
import SwiftUI


struct SplitView: View {
    @State private var isPresentingNewDayView = false
    @State private var shareSheetIsPresented = false
    @Binding var split: Split
    
    @Environment(\.scenePhase) private var scenePhase
    
    let saveAction: () -> Void
    func save() {
        do {
            let data = try JSONEncoder().encode(split)
            let outfile = fileURL
            try data.write(to: outfile)
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("send.data")
    var body: some View {
            VStack {
                List {
                    Section(header: HStack { Spacer(); Text("Current Day").font(.title3); Spacer()})
                    {
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
                            .onTapGesture {
                                save()
                            }
                    }
                    ToolbarItem {
                        Button(action: {isPresentingNewDayView = true}) {
                            Image(systemName: "plus")
                        }
                    }
                    /*ToolbarItem {
                        Button(action: { self.shareSheetIsPresented = true }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .frame(width: 44, height: 44, alignment: .center)
                        .sheet(isPresented: $shareSheetIsPresented) {
                            UIActivityViewController(
                                activityItems: [fileURL], applicationActivities: []).popoverPresentationController
                        }
                    } */
                }
                .sheet(isPresented: $isPresentingNewDayView) {
                    NavigationStack {
                        NewDayView(split: $split, isPresentingNewDayView: $isPresentingNewDayView)
                    }
                }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .onAppear() {
            save()
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView(split: .constant(Split.sampleData), saveAction: {} )
    }
}



