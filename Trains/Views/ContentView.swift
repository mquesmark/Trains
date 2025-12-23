import SwiftUI

enum TabKind: Int {
    case schedule
    case settings
}

struct ContentView: View {
    @State private var tab: TabKind = .schedule

    var body: some View {
        TabView(selection: $tab) {

            Tab(value: .schedule) {
                MainScreenView()
            } label: {
                Image(tab == .schedule
                      ? .scheduleActive
                      : .scheduleInactive)
            }

            Tab(value: .settings) {
                ErrorScreenView(errorType: .serverError)
            } label: {
                Image(tab == .settings
                      ? .settingsActive
                      : .settingsInactive)
            }
        }
    }
}

#Preview {
    ContentView()
}
#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
