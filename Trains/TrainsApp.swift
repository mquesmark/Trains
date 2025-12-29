import SwiftUI

@main
struct TrainsApp: App {
    @StateObject private var errorState = AppErrorState()
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundYP
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.3)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(errorState)
                .preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
        }
    }
}
