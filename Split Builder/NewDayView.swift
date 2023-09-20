import SwiftUI

struct NewDayView: View {
    @State private var newDay = Day(name: "", exercises: [], theme: .sky)
    @Binding var split: Split
    @Binding var isPresentingNewDayView: Bool
    var body: some View {
        NavigationStack {
            EditDayView(day: $newDay)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            split.dayList.append(newDay)
                            isPresentingNewDayView = false
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresentingNewDayView = false
                        }
                    }
                }
        }
    }
}


struct NewDayView_Preview: PreviewProvider {
    static var previews: some View {
        NewDayView(split: .constant(Split.sampleData), isPresentingNewDayView: .constant(true))
    }
}
