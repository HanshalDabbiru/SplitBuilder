import SwiftUI

struct ThemePicker: View {
    @Binding var selectedTheme: Theme
    var body: some View {
        Picker("Color", selection: $selectedTheme) {
            ForEach(Theme.allCases) { theme in
                Text(theme.name)
                            .padding(4)
                            .frame(maxWidth: .infinity)
                            .background(theme.mainColor)
                            .foregroundColor(theme.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .tag(theme)
            }
        }
        .pickerStyle(.menu)
    }
}

struct ThemePicker_Previews: PreviewProvider {
    @State private static var selectedTheme: Theme = .bubblegum
    static var previews: some View {
        ThemePicker(selectedTheme: $selectedTheme)
    }
}
