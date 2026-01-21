import SwiftUI

struct CitySelectionView: View {
    let target: PickTarget
    @Binding var path: NavigationPath

    @StateObject private var viewModel: CitySelectionViewModel
    init(
        target: PickTarget,
        path: Binding<NavigationPath>,
        stationsRepository: StationsRepository
    ) {
        self.target = target
        self._path = path
        self._viewModel = StateObject(
            wrappedValue: CitySelectionViewModel(
                stationsRepository: stationsRepository
            )
        )
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                CityLoadingSkeletonView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
                            .foregroundStyle(Color(.label))
                    }
                    .frame(height: 60)
                    .contentShape(Rectangle())
                    .listRowInsets(
                        EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.backgroundYP)
                    .onTapGesture {
                        didSelectCity(city)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: viewModel.filteredCities)
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
                    if value.translation.width > 80
                        && abs(value.translation.height) < 40 && !path.isEmpty
                    {
                        path.removeLast()
                    }
                }
        )
    }

    private struct CityLoadingSkeletonView: View {
        private let itemsCount: Int = 12

        var body: some View {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<itemsCount, id: \.self) { _ in
                        CitySkeletonRowView()
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .background(Color.backgroundYP)
            .accessibilityHidden(true)
        }
    }

    private struct CitySkeletonRowView: View {
        var body: some View {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 170, height: 18)

                Spacer()

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 14, height: 14)
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.backgroundYP)
            .shimmer()
        }
    }

    private func didSelectCity(_ city: City) {
        viewModel.searchText = ""
        path.append(Route.stations(target, city: city))
    }
}
