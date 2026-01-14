import SwiftUI

struct StationSelectionView: View {

    let target: PickTarget
    let city: String
    @Binding var path: [Route]
    @Binding var fromCity: String?
    @Binding var fromStation: String?
    @Binding var toCity: String?
    @Binding var toStation: String?

    @StateObject private var viewModel: StationSelectionViewModel

    init(
        target: PickTarget,
        city: String,
        path: Binding<[Route]>,
        fromCity: Binding<String?>,
        fromStation: Binding<String?>,
        toCity: Binding<String?>,
        toStation: Binding<String?>
    ) {
        self.target = target
        self.city = city
        self._path = path
        self._fromCity = fromCity
        self._fromStation = fromStation
        self._toCity = toCity
        self._toStation = toStation
        self._viewModel = StateObject(wrappedValue: StationSelectionViewModel(city: city))
    }

    var body: some View {
        Group {
            if viewModel.isNotFoundStation {
                Text("Станция не найдена")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.filteredStations, id: \.self) { station in
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
            text: $viewModel.searchText,
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
