// shows how a day should be displayed in the SplitView

import SwiftUI

struct DayCardView: View {
    @Binding var day: Day
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack() {
                VStack {
                    Text(day.name)
                        .font(.title)
                        .frame(width: 100)
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
                
            }.foregroundColor(day.theme.accentColor)
                .background(day.theme.mainColor)
                .padding(.vertical)
            Spacer()
        }
    }
}

struct DayCardView_Preview: PreviewProvider {
    static var day = Day.sampleData
    static var previews: some View {
        DayCardView(day: .constant(day))
    }
}
