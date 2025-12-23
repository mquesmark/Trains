import SwiftUI

struct CarriersResultsView: View {
    let allCarriers: [CarrierCardModel] = Mocks.mockCarrierCards
    let routeString: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 16) {
                Text(routeString)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                List {
                    ForEach(allCarriers) { carrier in
                        CarrierCardView(carrier: carrier)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
                .padding(.bottom, 24)
            }
            Button("Уточнить время") {
                filtersButtonTapped()
            }
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blueUniversal)
            )
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color.white)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }
    
    private func filtersButtonTapped() {
        
    }
}

#Preview {
    CarriersResultsView(routeString: "Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)")
}
#Preview {
    CarriersResultsView(routeString: "Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)")
        .preferredColorScheme(.dark)
}
