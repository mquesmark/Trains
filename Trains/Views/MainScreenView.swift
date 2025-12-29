import SwiftUI

enum Route: Hashable {
    case cities(PickTarget)
    case stations(PickTarget, city: String)
    case results(routeString: String)
    case carrierInfo
}

struct MainScreenView: View {

    var canSearch: Bool {
        fromCity != nil && fromStation != nil && toCity != nil && toStation != nil
    }
    var routeString: String {
        "\(fromCity!) (\(fromStation!)) → \(toCity!) (\(toStation!))"
    }
    
    @State private var path: [Route] = []
    @State private var fromCity: String? = nil
    @State private var fromStation: String? = nil
    @State private var toCity: String? = nil
    @State private var toStation: String? = nil

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                DirectionView(
                    fromCity: $fromCity,
                    fromStation: $fromStation,
                    toCity: $toCity,
                    toStation: $toStation,
                    onFromTap: { path.append(.cities(.from)) },
                    onToTap: { path.append(.cities(.to)) }
                )
                .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))

                if canSearch {
                    Button {
                        searchTapped()
                    } label: {
                        Text("Найти")
                            .frame(width: 150, height: 60)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.blueUniversal)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .background(.backgroundYP)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .cities(let target):
                    CitySelectionView(target: target, path: $path)
                        .toolbar(.hidden, for: .tabBar)
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    path.removeLast()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundStyle(Color(.label))
                            }
                        }
                case .stations(let target, let city):
                    StationSelectionView(
                        target: target,
                        city: city,
                        path: $path,
                        fromCity: $fromCity,
                        fromStation: $fromStation,
                        toCity: $toCity,
                        toStation: $toStation
                    )
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                path.removeLast()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundStyle(Color(.label))
                        }
                    }

                case .results(let routeString):
                    CarriersResultsView(routeString: routeString, path: $path)
                        .toolbar(.hidden, for: .tabBar)
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    path.removeLast()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundStyle(Color(.label))
                            }
                        }
                case .carrierInfo:
                    CarrierInfoView()
                }

            }
        }
    }

    private func searchTapped() {
        path.append(.results(routeString: routeString))
    }
}

#Preview {
    MainScreenView()

}
