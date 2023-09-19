import SwiftUI

struct NewDayView: View {
    @State private var newDay = Day.emptyDay
    @Binding var split: Split
    @Binding var isPresentingNewDayView: Bool
    var body: some View {
        NavigationStack {
            EditDayView(day: $newDay)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            split.dayList.append(newDay)
                            print(split)
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
