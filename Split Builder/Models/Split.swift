import Foundation

struct Split: Identifiable, Codable{
    var name: String
    var dayList: [Day]
    var id: UUID = UUID()
    var theme: Theme
    var currentDate: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.weekday, from: date)
    }
    
    func intToDay(i: Int) -> String {
        switch i {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    var currentDay: Int {
        let weekday = intToDay(i: currentDate)
        for (index, day) in dayList.enumerated() {
            for wd in day.days  {
                if(wd.rawValue == weekday) { return index; }
            }
        }
        return -1
    }   
}

extension Split {
    static let sampleData: Split = Split(name: "PPL", dayList:
    [
        Day(name: "Push", exercises:
        [
            Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .orange),
            Exercise(name: "Dips", weight: 30, sets: 3, reps: 12, theme: .oxblood),
            Exercise(name: "Chest Press", weight: 90, sets: 3, reps: 12, theme: .seafoam),
            Exercise(name: "Cable Flies", weight: 30, sets: 3, reps: 12, theme: .sky)
        ], theme: .periwinkle),
        Day(name: "Pull", exercises:
        [
            Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .bubblegum),
            Exercise(name: "Dips", weight: 185, sets: 3, reps: 12, theme: .lavender),
            Exercise(name: "Chest Press", weight: 185, sets: 3, reps: 12, theme: .navy),
            Exercise(name: "Cable Flies", weight: 185, sets: 3, reps: 12, theme: .tan)
        ], theme: .buttercup)
    ], theme: Theme.lavender)
    
    static let sdata: [Day] = [
        Day(name: "Push", exercises:
        [
            Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .orange),
            Exercise(name: "Dips", weight: 30, sets: 3, reps: 12, theme: .oxblood),
            Exercise(name: "Chest Press", weight: 90, sets: 3, reps: 12, theme: .seafoam),
            Exercise(name: "Cable Flies", weight: 30, sets: 3, reps: 12, theme: .sky)
        ], theme: .periwinkle),
        Day(name: "Pull", exercises:
        [
            Exercise(name: "Bench Press", weight: 185, sets: 3, reps: 12, theme: .bubblegum),
            Exercise(name: "Dips", weight: 185, sets: 3, reps: 12, theme: .lavender),
            Exercise(name: "Chest Press", weight: 185, sets: 3, reps: 12, theme: .navy),
            Exercise(name: "Cable Flies", weight: 185, sets: 3, reps: 12, theme: .tan)
        ], theme: .buttercup)
    ]
}
