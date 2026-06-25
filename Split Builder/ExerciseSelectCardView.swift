import SwiftUI

struct ExerciseSelectCardView: View {
    @Binding var exercise: Exercise

    var body: some View {
        VStack {
            TextField("Exercise Name", text: $exercise.name)

            ForEach(0..<exercise.plannedSetCount, id: \.self) { i in
                VStack(alignment: .leading) {
                    HStack {
                        Text("Set \(i + 1)")
                            .font(.body)
                        Spacer()
                        Button(role: .destructive) {
                            removeSet(at: i)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                    HStack {
                        Slider(value: $exercise.setList[i].weight, in: 0...300, step: 5) {
                            Text("Weight")
                        }
                        HStack {
                            Text("\(Int(exercise.setList[i].weight)) lbs")
                            Image(systemName: "dumbbell.fill")
                        }
                        .fixedSize()
                    }
                    Stepper("\(exercise.setList[i].reps) reps",
                            value: $exercise.setList[i].reps, in: 0...20)
                }
                .padding(.vertical)

                if i < exercise.plannedSetCount - 1 {
                    Divider()
                }
            }

            HStack {
                Spacer()
                Button(action: addSet) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(exercise.theme.mainColor)
                            .font(.system(size: 35))
                        Text("Add Set")
                            .foregroundColor(exercise.theme.mainColor)
                    }
                }
                Spacer()
            }
        }
    }

    private func addSet() {
        let template = exercise.setList[exercise.setList.count - 1]
        exercise.plannedSetCount += 1
        exercise.setList.append(WorkoutSet(weight: template.weight, reps: template.reps))
    }

    private func removeSet(at index: Int) {
        exercise.plannedSetCount -= 1
        if exercise.plannedSetCount >= 1 {
            exercise.setList.remove(at: index)
        }
        // When plannedSetCount reaches 0, setList keeps its one template entry.
    }
}

struct ExerciseSelectCardView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ExerciseSelectCardView(exercise: .constant(Exercise.sampleData))
        }
    }
}
