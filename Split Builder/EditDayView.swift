import SwiftUI

struct EditDayView: View {
    @Binding var day: Day
    @Environment(\.dismiss) private var dismiss

    @State private var draftDay: Day
    @State private var originalDay: Day
    @State private var showDiscardAlert = false

    init(day: Binding<Day>) {
        self._day = day
        self._draftDay = State(initialValue: day.wrappedValue)
        self._originalDay = State(initialValue: day.wrappedValue)
    }

    private var hasChanges: Bool {
        draftDay != originalDay
    }

    private var dayNameIsEmpty: Bool {
        draftDay.name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Day Info")) {
                    TextField("Day Name", text: $draftDay.name)
                    DayPicker(editDay: $draftDay)
                }
                Section(header: Text("Theme")) {
                    ThemePicker(selectedTheme: $draftDay.theme)
                }
                Section(header: Text("Exercises")) {
                    List($draftDay.exercises, editActions: .all) { $exercise in
                        VStack {
                            ExerciseSelectCardView(exercise: $exercise)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        let newExercise = Exercise(name: "", weight: 0, sets: 0, reps: 0, theme: draftDay.generateTheme())
                        draftDay.exercises.append(newExercise)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(draftDay.theme.mainColor)
                            .font(.system(size: 50))
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if hasChanges {
                        showDiscardAlert = true
                    } else {
                        dismiss()
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    draftDay.exercises.removeAll {
                        $0.name.trimmingCharacters(in: .whitespaces).isEmpty
                    }
                    day = draftDay
                    dismiss()
                }
                .disabled(dayNameIsEmpty)
            }
        }
        .alert("Discard Changes?", isPresented: $showDiscardAlert) {
            Button("Discard", role: .destructive) { dismiss() }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("Are you sure you want to discard your changes?")
        }
    }
}


struct EditDayView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditDayView(day: .constant(Day.sampleData))
        }
    }
}
