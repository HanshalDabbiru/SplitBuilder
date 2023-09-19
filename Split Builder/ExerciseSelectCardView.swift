import SwiftUI

struct ExerciseSelectCardView: View {
    @Binding var exercise: Exercise
    
    var body: some View {
        VStack() {
            VStack {
                TextField("Exercise Name", text: $exercise.name)
                HStack {
                    Slider(value: $exercise.weight, in: 5...300, step: 5) {
                        Text("Weight")
                    }
                    HStack {
                        Text("\(exercise.weight, specifier: "%.1f") lbs")
                        Image(systemName: "dumbbell.fill")
                        
                    }
                }
                Stepper("\(exercise.sets) sets", value: $exercise.sets, in: 0...10)
                Stepper("\(exercise.reps) reps", value: $exercise.reps, in: 0...20)
            }        }
    }
}

struct ExerciseSelectCardView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSelectCardView(exercise: .constant(Exercise.emptyExercise))
            .previewLayout(.fixed(width: 400, height: 60))
    }
}


   
