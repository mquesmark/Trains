import SwiftUI

struct StationSelectionView: View {

    let target: PickTarget
    let city: String
    @Binding var path: [Route]
    @Binding var fromCity: String?
    @Binding var fromStation: String?
    @Binding var toCity: String?
    @Binding var toStation: String?
    
    private var stations: [String] {
        switch city {
        case "Москва":
            return Mocks.moscowMockStations
        case "Санкт-Петербург":
            return Mocks.spbMockStations
        case "Новосибирск":
            return Mocks.novosibirskMockStations
        case "Казань":
            return Mocks.kazanMockStations
        case "Омск":
            return Mocks.omskMockStations
        case "Томск":
            return Mocks.tomskMockStations
        case "Челябинск":
            return Mocks.chelyabinskMockStations
        case "Иркутск":
            return Mocks.irkutskMockStations
        case "Ярославль":
            return Mocks.yaroslavlMockStations
        case "Нижний Новгород":
            return Mocks.nizhnyNovgorodMockStations
        default:
            return []
        }
    }

    @State private var searchText = ""

    private var filteredStations: [String] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        Group {
            if !searchText.isEmpty && filteredStations.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredStations, id: \.self) { station in
                    HStack {
                        Text(station)
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(.label))
                    }
                    .frame(height: 60)
                    .contentShape(Rectangle())
                    .listRowBackground(Color.backgroundYP)
                    .listRowInsets(
                        EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                    )
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        didSelectStation(station)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .background(.backgroundYP)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
    }

    private func didSelectStation(_ station: String) {
        switch target {
        case .from:
            fromCity = city
            fromStation = station
        case .to:
            toCity = city
            toStation = station
        }
        path.removeAll()
    }
}
