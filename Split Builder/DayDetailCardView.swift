// shows how a day should be displayed in the SplitView

import SwiftUI

struct DayDetailCardView: View {
    var day: Day
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(day.name).font(.title)
                Spacer()
            }
            HStack() {
                VStack {
                    if day.exercises.count > 0 {
                        ForEach(day.exercises) { exercise in
                            Text(exercise.name)
                        }
                    }
                    else {
                        Text("No Exercises Today")
                    }
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(day.exercises.count) exercises")
                        .font(.body)
                    HStack {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text("\(day.time()) minutes")
                            .font(.caption2)
                            .fixedSize()
                    }
                }
                
            }.padding(.top)
            Spacer()
        }
        .foregroundColor(day.theme.accentColor)
            .background(day.theme.mainColor)
            .padding(.vertical)
    }
}

struct DayDetailCardView_Preview: PreviewProvider {
    static var day = Day.sampleData
    static var previews: some View {
        DayDetailCardView(day: day)
    }
}

