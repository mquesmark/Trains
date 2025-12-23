import SwiftUI

struct CarriersResultsView: View {
    let allCarriers: [CarrierCardModel] = Mocks.mockCarrierCards
    let routeString: String
    @Binding var path: [Route]
    
    @State private var timeSelection: Set<TimeIntervals> = []
    @State private var showTransfers: Bool? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 16) {
                Text(routeString)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                if allCarriers.isEmpty {
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(allCarriers) { carrier in
                            CarrierCardView(carrier: carrier)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 80)
                    }
                    .padding(.bottom, 24)
                }
            }
            
            if !allCarriers.isEmpty {
                NavigationLink {
                    FiltersView(
                        timeSelection: $timeSelection,
                        showTransfers: $showTransfers
                    )
                    .toolbar(.hidden, for: .tabBar)
                } label: {
                    Text("Уточнить время")
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blueUniversal)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
}

struct CarriersResultsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                CarriersResultsView(
                    routeString: "Москва — Санкт-Петербург",
                    path: .constant([])
                )
            }
            .preferredColorScheme(.light)

            NavigationStack {
                CarriersResultsView(
                    routeString: "Москва — Санкт-Петербург",
                    path: .constant([])
                )
            }
            .preferredColorScheme(.dark)
        }
    }
}
