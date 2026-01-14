import SwiftUI

/// Этот экран намеренно реализован без ViewModel.
/// Здесь нет загрузки данных или бизнес-логики: экран использует только локальные пользовательские настройки через "@AppStorage",
/// поэтому дополнительный слой ViewModel был бы избыточным.

struct SettingsView: View {

    // MARK: - Storage

    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false

    // MARK: - View

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                settingsContent
                Spacer()
                footer
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundYP)
        }
    }

    // MARK: - Content

    private var settingsContent: some View {
        VStack(spacing: 0) {
            darkThemeToggle
            userAgreementLink
        }
    }

    private var darkThemeToggle: some View {
        HStack {
            Toggle("Темная тема", isOn: $isDarkThemeEnabled)
                .tint(.blueUniversal)
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
        .font(.system(size: 17, weight: .regular))
    }

    private var userAgreementLink: some View {
        NavigationLink {
            UserAgreementView()
        } label: {
            HStack {
                Text("Пользовательское соглашение")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(.label))
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            .font(.system(size: 17, weight: .regular))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 16) {
            Text("Приложение использует API «Яндекс.Расписания»")
                .font(.system(size: 12, weight: .regular))

            Text("Версия 1.0 (beta)")
                .font(.system(size: 12, weight: .regular))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

#Preview {
    SettingsView()
}
