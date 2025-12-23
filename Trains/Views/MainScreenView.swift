import SwiftUI

struct MainScreenView: View {
    @State var canSearch: Bool = true
    
    var body: some View {
        VStack {
            DirectionView()
                .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))
            
            if canSearch {
                Button("Найти") {
                    searchTapped()
                }
                    .frame(width: 150, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blueUniversal)
                    )
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
            }
                Spacer()
        }
        .background(.backgroundYP)
    }
    
    private func searchTapped() {
        
    }
}

#Preview {
    MainScreenView()

}

#Preview {
    MainScreenView()
        .preferredColorScheme(.dark)
}
