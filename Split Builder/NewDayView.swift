import SwiftUI

struct NewDayView: View {
    @State private var newDay = Day(name: "", exercises: [], theme: .sky)
    @Binding var split: Split
    @Binding var isPresentingNewDayView: Bool
    @State private var showDiscardAlert = false

    private var dayNameIsEmpty: Bool {
        newDay.name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // Compare fields rather than the whole struct to avoid UUID mismatch on two fresh Day()s.
    private var hasChanges: Bool {
        !newDay.name.trimmingCharacters(in: .whitespaces).isEmpty ||
        !newDay.exercises.isEmpty ||
        !newDay.days.isEmpty ||
        newDay.theme != .sky
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Day Info")) {
                    TextField("Day Name", text: $newDay.name)
                    DayPicker(editDay: $newDay)
                }
                Section(header: Text("Theme")) {
                    ThemePicker(selectedTheme: $newDay.theme)
                }
                Section(header: Text("Exercises")) {
                    List($newDay.exercises, editActions: .all) { $exercise in
                        VStack {
                            ExerciseSelectCardView(exercise: $exercise)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        let newExercise = Exercise(name: "", weight: 0, sets: 0, reps: 0, theme: newDay.generateTheme())
                        newDay.exercises.append(newExercise)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(newDay.theme.mainColor)
                            .font(.system(size: 50))
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
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
