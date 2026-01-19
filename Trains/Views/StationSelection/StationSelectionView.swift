import SwiftUI

struct StationSelectionView: View {
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(\.dismiss) private var dismiss
    let target: PickTarget
    let city: City
    @Binding var path: NavigationPath
    @Binding var fromCity: City?
    @Binding var fromStation: Station?
    @Binding var toCity: City?
    @Binding var toStation: Station?

    @StateObject private var viewModel: StationSelectionViewModel

    @State private var dismissStage: Int = 0

    init(
        target: PickTarget,
        city: City,
        path: Binding<NavigationPath>,
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
                .animation(.easeInOut(duration: 0.15), value: viewModel.filteredStations)
                .listStyle(.plain)
            }
        }
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .background(.backgroundYP)
        .task {
            await viewModel.load()
        }
        .task(id: dismissStage) {
            await runDismissStageIfNeeded()
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
            fromStation = station

        case .to:
            toCity = city
            toStation = station
        }

        dismissSearch()
        viewModel.searchText = ""

        // Запускаем staged-dismiss flow (workaround бага навигации).
        // Этап 1: dismiss, затем переключение на этап 2.
        // Этап 2: второй dismiss, затем сброс стека навигации.
        dismissStage = 1
    }

    private func runDismissStageIfNeeded() async {
        guard dismissStage != 0 else { return }

        switch dismissStage {
        case 1:
            // Первый dismiss
            await MainActor.run {
                dismiss()
            }

            // Переключаемся на этап 2 на следующем тике
            await Task.yield()
            await MainActor.run {
                dismissStage = 2
            }

        case 2:
            // Второй dismiss
            await MainActor.run {
                dismiss()
            }

            // После второго dismiss сбрасываем стек навигации на главный экран
            await Task.yield()
            await MainActor.run {
                path = NavigationPath()
                dismissStage = 0
            }

        default:
            await MainActor.run { dismissStage = 0 }
        }
    }
}
