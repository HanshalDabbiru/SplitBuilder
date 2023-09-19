import SwiftUI

enum Days: String, CaseIterable, Codable {
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

struct DayPicker: View {
    @State private var selected: [Days] = []
    @Binding var editDay: Day
    var body: some View {
        HStack {
            ForEach(Days.allCases, id: \.self) { day in
                ZStack {
                    Circle()
                        .fill(editDay.days.contains(day) ? editDay.theme.mainColor : Color.gray)
                    Text(String(day.rawValue.first!))
                        .bold()
                        .foregroundColor(.white)
                }.onTapGesture {
                    if(editDay.days.contains(day)) {editDay.days.removeAll(where: {$0 == day})}
                    else {
                        editDay.days.append(day)
                    }
                }
            }
        }
    }
}


struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {
        DayPicker(editDay: .constant(Day.sampleData))
    }
}

