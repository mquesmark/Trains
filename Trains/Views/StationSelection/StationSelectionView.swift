import SwiftUI

struct StationSelectionView: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    let target: PickTarget
    let city: City
    @Binding var path: [Route]
    @Binding var fromCity: City?
    @Binding var fromStation: Station?
    @Binding var toCity: City?
    @Binding var toStation: Station?

    @StateObject private var viewModel: StationSelectionViewModel

    init(
        target: PickTarget,
        city: City,
        path: Binding<[Route]>,
        fromCity: Binding<City?>,
        fromStation: Binding<Station?>,
        toCity: Binding<City?>,
        toStation: Binding<Station?>,
        stationsRepository: StationsRepository
    ) {
        self.target = target
        self.city = city
        self._path = path
        self._fromCity = fromCity
        self._fromStation = fromStation
        self._toCity = toCity
        self._toStation = toStation
        self._viewModel = StateObject(
            wrappedValue: StationSelectionViewModel(
                city: city,
                stationsRepository: stationsRepository
            )
        )
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Загрузка станций...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorText = viewModel.errorText {
                Text(errorText)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isNotFoundStation {
                Text("Станция не найдена")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.filteredStations) { station in
                    HStack {
                        Text(station.title)
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
        .task {
            await viewModel.load()
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 80
                        && abs(value.translation.height) < 40 && !path.isEmpty
                    {
                        path.removeLast()
                    }
                }
        )
    }

    private func didSelectStation(_ station: Station) {
        switch target {
        case .from:
            fromCity = city
            // Хак: принудительно меняем значение, чтобы onChange сработал даже при выборе той же станции
            fromStation = nil
            Task { @MainActor in
                await Task.yield()
                fromStation = station
            }

        case .to:
            toCity = city
            // Хак: принудительно меняем значение, чтобы onChange сработал даже при выборе той же станции
            toStation = nil
            Task { @MainActor in
                await Task.yield()
                toStation = station
            }
        }

        dismissSearch()
        viewModel.searchText = ""
    }
}
