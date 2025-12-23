import SwiftUI
import Combine

final class AppErrorState: ObservableObject {
    @Published var error: ErrorScreenView.ErrorType? = nil
}

extension ErrorScreenView.ErrorType: Identifiable {
    var id: String {
        switch self {
        case .serverError: return "serverError"
        case .noInternet: return "noInternet"
        }
    }
}

enum TabKind: Int {
    case schedule
    case settings
}

struct ContentView: View {
    @State private var tab: TabKind = .schedule
    @StateObject private var errorState = AppErrorState()

    var body: some View {
        TabView(selection: $tab) {
            MainScreenView()
                .tabItem {
                    Image(tab == .schedule
                          ? .scheduleActive
                          : .scheduleInactive)
                }
                .tag(TabKind.schedule)

            ErrorScreenView(errorType: .serverError)
                .tabItem {
                    Image(tab == .settings
                          ? .settingsActive
                          : .settingsInactive)
                }
                .tag(TabKind.settings)
        }
        .environmentObject(errorState)
        .fullScreenCover(item: $errorState.error) { error in
            ErrorScreenView(errorType: error)
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
