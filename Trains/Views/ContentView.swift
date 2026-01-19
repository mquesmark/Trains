import SwiftUI
import Combine

@MainActor
final class AppErrorState: ObservableObject {
    @Published var error: ErrorType? = nil
}

enum TabKind: Int {
    case schedule
    case settings
}

struct ContentView: View {
    @State private var tab: TabKind = .schedule
    @EnvironmentObject private var errorState: AppErrorState

    var body: some View {
        TabView(selection: $tab) {
            MainScreenView()
                .tabItem {
                    tabIcon(for: .schedule)
                }
                .tag(TabKind.schedule)

            SettingsView()
                .tabItem {
                    tabIcon(for: .settings)
                }
                .tag(TabKind.settings)
        }
        .fullScreenCover(item: $errorState.error) { error in
            ErrorScreenView(errorType: error)
        }
    }

    // MARK: - Tab Icons

    private func tabIcon(for kind: TabKind) -> some View {
        Image(tab == kind ? kind.activeIcon : kind.inactiveIcon)
    }
}

// MARK: - TabKind Icons

private extension TabKind {
    var activeIcon: ImageResource {
        switch self {
        case .schedule: return .scheduleActive
        case .settings: return .settingsActive
        }
    }

    var inactiveIcon: ImageResource {
        switch self {
        case .schedule: return .scheduleInactive
        case .settings: return .settingsInactive
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppErrorState())
}

#Preview {
    ContentView()
        .environmentObject(AppErrorState())
        .preferredColorScheme(.dark)
}
