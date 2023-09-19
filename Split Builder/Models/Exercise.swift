//

import Foundation

struct Exercise: Identifiable, Codable {
    var name: String
    var weight: Double
    var sets: Int
    var reps: Int
    var isChecked: Bool = false
    var id: UUID
    var theme: Theme
    
    init(name: String, weight: Double, sets: Int, reps: Int, isChecked: Bool = false, id: UUID = UUID(), theme: Theme) {
        self.name = name
        self.weight = weight
        self.sets = sets
        self.reps = reps
        self.isChecked = isChecked
        self.id = id
        self.theme = theme
    }
    
    mutating func toggle() {
        if isChecked {
            isChecked = false
        }
        else
        {
            isChecked = true
        }
    }
}

extension Exercise {
    static let sampleData: Exercise = Exercise(name: "Dips", weight: 185, sets: 3, reps: 12, theme: .bubblegum)
    
}

extension Exercise {
    static let emptyExercise: Exercise = Exercise(name: "", weight: 0, sets: 0, reps: 0, theme: .sky)
    func newExercise() -> Exercise { return Exercise(name: "", weight: 0, sets: 0, reps: 0, theme: .sky) }
}
