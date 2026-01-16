import SwiftUI

struct CitySelectionView: View {
    let target: PickTarget
    @Binding var path: [Route]
        
    @StateObject private var viewModel: CitySelectionViewModel
    init(target: PickTarget, path: Binding<[Route]>, stationsRepository: StationsRepository) {
        self.target = target
        self._path = path
        self._viewModel = StateObject(wrappedValue: CitySelectionViewModel(stationsRepository: stationsRepository))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Загрузка городов...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorText = viewModel.errorText {
                Text(errorText)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isNotFoundState {
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.filteredCities) { city in
                    HStack {
                        Text(city.title)
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(.label))
                    }
                    .frame(height: 60)
                    .contentShape(Rectangle())
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.backgroundYP)
                    .onTapGesture {
                        didSelectCity(city)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
        .background(.backgroundYP)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
        .task {
            await viewModel.load()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 80 && abs(value.translation.height) < 40 && !path.isEmpty {
                        path.removeLast()
                    }
                }
        )
    }
    
    private func didSelectCity(_ city: City) {
        path.append(.stations(target, city: city.title))
    }
}
