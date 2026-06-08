import SwiftUI

struct DayView: View {
    @Binding var day: Day

    var body: some View {
        List {
            Section(header: HStack {
                Spacer()
                Text(day.name).font(.largeTitle).multilineTextAlignment(.center)
                Spacer()
            }) {
                ForEach($day.exercises) { $exercise in
                    ExerciseCardView(exercise: $exercise)
                        .listRowBackground(exercise.theme.mainColor)
                }
            }
        }
        .navigationTitle(day.name)
    }
}

struct Day_Previews: PreviewProvider {
    static var day: Day = Day.sampleData
    static var previews: some View {
        NavigationStack {
            DayView(day: .constant(day))
        }
    }
}
