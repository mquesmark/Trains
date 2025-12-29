import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Toggle("Темная тема", isOn: $isDarkThemeEnabled)
                            .tint(.blueUniversal)
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                    .font(.system(size: 17, weight: .regular))

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
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.system(size: 12, weight: .regular))
                    
                    Text("Версия 1.0 (beta)")
                        .font(.system(size: 12, weight: .regular))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundYP)
        }
    }
}


#Preview {
    SettingsView()
}
