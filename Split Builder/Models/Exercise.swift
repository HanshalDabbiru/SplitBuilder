import Foundation

struct WorkoutSet: Identifiable, Codable, Equatable {
    var id: UUID
    var weight: Double
    var reps: Int
    var isCompleted: Bool

    init(weight: Double, reps: Int, isCompleted: Bool = false, id: UUID = UUID()) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
    }
}

struct Exercise: Identifiable, Equatable {
    var name: String
    var setList: [WorkoutSet]   // always has >= 1 entry; index 0 is the template when plannedSetCount == 0
    var plannedSetCount: Int    // the user-visible sets count; drives the stepper
    var isChecked: Bool
    var id: UUID
    var theme: Theme

    // Back-compat computed properties — always safe because setList is never empty.
    var weight: Double { setList[0].weight }
    var reps: Int      { setList[0].reps }
    var sets: Int      { plannedSetCount }

    init(name: String, weight: Double, sets: Int, reps: Int,
         isChecked: Bool = false, id: UUID = UUID(), theme: Theme) {
        self.name = name
        self.plannedSetCount = sets
        // Ensure at least 1 entry so weight/reps are always readable.
        let count = max(sets, 1)
        self.setList = (0..<count).map { _ in WorkoutSet(weight: weight, reps: reps) }
        self.isChecked = isChecked
        self.id = id
        self.theme = theme
    }

    mutating func toggle() {
        isChecked.toggle()
    }
}

// Handles three on-disk formats:
//  1. Current  — setList + plannedSetCount present
//  2. Intermediate — setList present, plannedSetCount absent (written by the previous model)
//  3. Legacy   — flat weight/reps/sets fields (original format before WorkoutSet)
extension Exercise: Codable {
    private enum CodingKeys: String, CodingKey {
        case name, setList, plannedSetCount, isChecked, id, theme
        case weight, reps, sets  // legacy keys
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name      = try c.decode(String.self, forKey: .name)
        isChecked = try c.decodeIfPresent(Bool.self, forKey: .isChecked) ?? false
        id        = try c.decode(UUID.self, forKey: .id)
        theme     = try c.decode(Theme.self, forKey: .theme)

        if let list = try c.decodeIfPresent([WorkoutSet].self, forKey: .setList) {
            // Formats 1 & 2: setList exists
            let storedCount = try c.decodeIfPresent(Int.self, forKey: .plannedSetCount)
            plannedSetCount = storedCount ?? list.count  // fall back to list.count for format 2
            setList = list.isEmpty ? [WorkoutSet(weight: 0, reps: 0)] : list
        } else {
            // Format 3: legacy flat fields
            let w = try c.decodeIfPresent(Double.self, forKey: .weight) ?? 0
            let r = try c.decodeIfPresent(Int.self,    forKey: .reps)   ?? 0
            let s = try c.decodeIfPresent(Int.self,    forKey: .sets)   ?? 1
            plannedSetCount = s
            setList = (0..<max(s, 1)).map { _ in WorkoutSet(weight: w, reps: r) }
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name,             forKey: .name)
        try c.encode(setList,          forKey: .setList)
        try c.encode(plannedSetCount,  forKey: .plannedSetCount)
        try c.encode(isChecked,        forKey: .isChecked)
        try c.encode(id,               forKey: .id)
        try c.encode(theme,            forKey: .theme)
    }
}

extension Exercise {
    static let sampleData: Exercise = Exercise(name: "Dips", weight: 185, sets: 3, reps: 12, theme: .bubblegum)
    static let emptyExercise: Exercise = Exercise(name: "", weight: 0, sets: 0, reps: 0, theme: .sky)
    func newExercise() -> Exercise { Exercise(name: "", weight: 0, sets: 0, reps: 0, theme: .sky) }
}
