Update ExerciseSelectCardView.swift to allow individual editing of weight and reps for each set instead of applying changes to all sets at once.

CONTEXT:
Currently, changing weight or reps applies to ALL sets. We need per-set editing so users can plan progressive overload or vary intensity across sets.

CURRENT CODE:
```swift
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

    private var weightBinding: Binding<Double> { /* loops through all sets */ }
    private var repsBinding: Binding<Int> { /* loops through all sets */ }
    private var setsBinding: Binding<Int> { 
        // Manages plannedSetCount and keeps setList sized correctly
        // When adding: uses last set as template
        // When removing: removes from end
    }
}
```

REQUIREMENTS:
1. Keep TextField at top for exercise name
2. REMOVE the sets stepper completely
3. Remove weightBinding and repsBinding (not needed anymore)
4. Show each set individually with label "Set 1", "Set 2", etc.
5. Each set needs individual weight slider and reps stepper
6. Only display sets up to plannedSetCount (use ForEach on 0..<exercise.plannedSetCount)
7. Bind directly to exercise.setList[index].weight and exercise.setList[index].reps
8. Add "Add Set" button at bottom that increases plannedSetCount and appends new WorkoutSet using last set as template
9. Optional: Add way to remove individual sets (minus button or leave for swipe actions)

DATA MODEL:
- exercise.setList is [WorkoutSet] where WorkoutSet has weight (Double) and reps (Int)
- exercise.plannedSetCount determines visible set count
- setList must be kept at max(plannedSetCount, 1) entries
- When adding set: copy last set's values for template

ADD SET BUTTON LOGIC:
```swift
Button(action: {
    let template = exercise.setList[exercise.setList.count - 1]
    exercise.plannedSetCount += 1
    exercise.setList.append(WorkoutSet(weight: template.weight, reps: template.reps))
}) {
    HStack {
        Image(systemName: "plus.circle.fill")
            .foregroundColor(exercise.theme.mainColor)
            .font(.system(size: 35))
        Text("Add Set")
            .foregroundColor(exercise.theme.mainColor)
    }
}
```

DESIGN REQUIREMENTS (see DESIGN.md for full details):
- Use VStack as main container
- TextField for exercise name at top
- ForEach for sets, each in its own VStack with padding
- Use Divider() between sets for visual separation
- Label each set with Text("Set \(index + 1)").font(.body)
- Weight slider: 0...300 range, step 5, show value as "\(Int(weight)) lbs" with dumbbell.fill icon
- Reps stepper: 0...20 range, show as "\(reps) reps"
- Add Set button at bottom, centered with Spacers, using plus.circle.fill icon
- Use .padding(.vertical) on each set's VStack for breathing room
- Consider wrapping sets in ScrollView if they can exceed screen height

EXPECTED STRUCTURE:
```
VStack {
    TextField("Exercise Name", ...)
    
    ForEach(0..<exercise.plannedSetCount) { index in
        VStack {
            Text("Set \(index + 1)")
            HStack { 
                Slider for weight
                HStack { weight display + dumbbell icon }
            }
            Stepper for reps
        }
        .padding(.vertical)
        
        if index < exercise.plannedSetCount - 1 {
            Divider()
        }
    }
    
    HStack {
        Spacer()
        Button("Add Set") { /* add logic */ }
        Spacer()
    }
}
```

Provide the complete updated ExerciseSelectCardView.swift file following the design system in DESIGN.md.
