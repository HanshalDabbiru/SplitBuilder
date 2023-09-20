import Foundation

struct Day: Identifiable, Codable {
    var name: String
    var exercises: [Exercise]
    var tempTotalExercises: [Exercise]
    var days: [Days]
    var theme: Theme
    var id: UUID
    var lastTheme: Theme?
    
    init(name: String, exercises: [Exercise], theme: Theme, id: UUID = UUID(), days: [Days] = []) {
        self.name = name
        self.exercises = exercises
        self.theme = theme
        self.id = id
        self.tempTotalExercises = exercises
        self.days = days
    }
    
    func time() -> Int {
        var time: Int = 0
        for exercise in exercises {
            time += exercise.sets * 3
        }
        return time
    }
    
    func generateTheme() -> Theme {
        var t = Theme.allCases.randomElement()!
        while(t == lastTheme) {
            t = Theme.allCases.randomElement()!
        }
        return t;
    }

    
}


 extension Day {
 static let sampleData: Day =
     Day(name: "Push", exercises:
     [
         Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .buttercup),
         Exercise(name: "Super long name", weight: 30, sets: 3, reps: 12, theme: .lavender),
         Exercise(name: "Chest Press", weight: 90, sets: 3, reps: 12, theme: .oxblood),
         Exercise(name: "Cable Flies", weight: 20, sets: 3, reps: 12, theme: .seafoam)
     ], theme: .magenta)
 
     static var emptyDay: Day {
         Day(name: "", exercises: [], theme: .sky)
     }
 
 }
 
