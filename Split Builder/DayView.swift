//shows all the exercisese that are in the split

import SwiftUI

struct DayView: View {
    @State private var isPresentingEditView = false
    @Binding var day: Day
    var body: some View {
        NavigationStack {
            List {
                Section(header: HStack {
                    Spacer()
                    Text(day.name) .font(.largeTitle) .multilineTextAlignment(.center)
                    Spacer()
                    
                })
                {
                    ForEach($day.exercises) { $exercise in
                        NavigationStack {
                            ExerciseCardView(exercise: $exercise)
                                
                        }.listRowBackground(exercise.theme.mainColor)
                    }
                }
            }

        }
    }
}

struct Day_Previews: PreviewProvider {
    static var day: Day = Day.sampleData
    static var previews: some View {
        DayView(day: .constant(day))
    }
}


