import SwiftUI

struct NewDayView: View {
    @State private var newDay = Day(name: "", exercises: [], theme: .sky)
    @Binding var split: Split
    @Binding var isPresentingNewDayView: Bool
    @State private var showDiscardAlert = false

    private var dayNameIsEmpty: Bool {
        newDay.name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // Field comparison avoids UUID mismatch between two freshly created Day()s.
    private var hasChanges: Bool {
        !newDay.name.trimmingCharacters(in: .whitespaces).isEmpty ||
        !newDay.exercises.isEmpty ||
        !newDay.days.isEmpty ||
        newDay.theme != .sky
    }

    var body: some View {
        DayFormView(day: $newDay)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if hasChanges {
                            showDiscardAlert = true
                        } else {
                            isPresentingNewDayView = false
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        newDay.exercises.removeAll {
                            $0.name.trimmingCharacters(in: .whitespaces).isEmpty
                        }
                        split.dayList.append(newDay)
                        isPresentingNewDayView = false
                    }
                    .disabled(dayNameIsEmpty)
                }
            }
            .alert("Discard Changes?", isPresented: $showDiscardAlert) {
                Button("Discard", role: .destructive) { isPresentingNewDayView = false }
                Button("Keep Editing", role: .cancel) { }
            } message: {
                Text("Are you sure you want to discard your changes?")
            }
    }
}

struct NewDayView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewDayView(split: .constant(Split.sampleData), isPresentingNewDayView: .constant(true))
        }
    }
}
