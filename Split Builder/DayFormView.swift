import SwiftUI

struct DayFormView: View {
    @Binding var day: Day

    var body: some View {
        Form {
            Section(header: Text("Day Info")) {
                TextField("Day Name", text: $day.name)
                DayPicker(editDay: $day)
            }
            Section(header: Text("Theme")) {
                ThemePicker(selectedTheme: $day.theme)
            }
            Section(header: Text("Exercises")) {
                List($day.exercises, editActions: .all) { $exercise in
                    VStack {
                        ExerciseSelectCardView(exercise: $exercise)
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    let newExercise = Exercise(name: "", weight: 0, sets: 0, reps: 0, theme: day.generateTheme())
                    day.exercises.append(newExercise)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(day.theme.mainColor)
                        .font(.system(size: 50))
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
    }
}

struct DayFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DayFormView(day: .constant(Day.sampleData))
        }
    }
}
