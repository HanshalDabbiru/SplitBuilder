// shows how the exercise should be displayed in the DayView


import SwiftUI

struct ExerciseCardView: View {
    @Binding var exercise: Exercise
    
    var body: some View {
        HStack {
            Button(action: { exercise.toggle() }) {
                Image(systemName: !exercise.isChecked ? "circle" : "checkmark.circle.fill")
            }
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text(exercise.name)
                        .font(.title3)
                    Image(systemName: "dumbbell.fill")
                }
                Text("\(exercise.weight, specifier: "%.1f") lbs")
                    .font(.caption2)
                Spacer()
            }
            Spacer()
            Text("\(exercise.sets)x\(exercise.reps)")
                .multilineTextAlignment(.leading)

        }
        .foregroundColor(exercise.theme.accentColor)
    }
}

struct ExerciseCardView_Previews: PreviewProvider {
    static var exercise = Exercise.sampleData
    static var previews: some View {
        ExerciseCardView(exercise: .constant(exercise))
            .previewLayout(.fixed(width: 400, height: 60))
            .background(exercise.theme.mainColor)
    }
}
