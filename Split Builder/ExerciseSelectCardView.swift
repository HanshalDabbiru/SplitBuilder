import SwiftUI

struct ExerciseSelectCardView: View {
    @Binding var exercise: Exercise

    var body: some View {
        VStack {
            TextField("Exercise Name", text: $exercise.name)

            HStack {
                Slider(value: weightBinding, in: 0...300, step: 5) {
                    Text("Weight")
                }
                HStack {
                    Text("\(Int(exercise.weight)) lbs")
                    Image(systemName: "dumbbell.fill")
                }
            }

            Stepper("\(exercise.sets) sets", value: setsBinding, in: 0...10)
            Stepper("\(exercise.reps) reps", value: repsBinding, in: 0...20)
        }
    }

    // setList always has >= 1 entry, so these loops are never no-ops —
    // weight and reps are readable and writable even when plannedSetCount is 0.
    private var weightBinding: Binding<Double> {
        Binding(
            get: { exercise.weight },
            set: { newWeight in
                for i in exercise.setList.indices {
                    exercise.setList[i].weight = newWeight
                }
            }
        )
    }

    private var repsBinding: Binding<Int> {
        Binding(
            get: { exercise.reps },
            set: { newReps in
                for i in exercise.setList.indices {
                    exercise.setList[i].reps = newReps
                }
            }
        )
    }

    // Reads and writes plannedSetCount (not setList.count).
    // setList is kept at max(plannedSetCount, 1) entries so index 0
    // always holds the current weight/reps as a template for future sets.
    private var setsBinding: Binding<Int> {
        Binding(
            get: { exercise.plannedSetCount },
            set: { newCount in
                exercise.plannedSetCount = newCount
                let target = max(newCount, 1)
                let cur = exercise.setList.count
                if target > cur {
                    let template = exercise.setList[cur - 1]
                    exercise.setList.append(contentsOf: (0..<(target - cur)).map { _ in
                        WorkoutSet(weight: template.weight, reps: template.reps)
                    })
                } else if target < cur {
                    exercise.setList = Array(exercise.setList.prefix(target))
                }
            }
        )
    }
}

struct ExerciseSelectCardView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSelectCardView(exercise: .constant(Exercise.sampleData))
            .previewLayout(.fixed(width: 400, height: 120))
    }
}
