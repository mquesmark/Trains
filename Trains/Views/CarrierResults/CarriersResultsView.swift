import SwiftUI

struct CarriersResultsView: View {
    @Binding var path: NavigationPath
    let fromStation: Station
    let fromCity: City
    let toStation: Station
    let toCity: City

    var routeString: String {
            return "\(fromCity.title) (\(fromStation.title)) → \(toCity.title) (\(toStation.title))"
    }

    @StateObject private var viewModel = CarriersResultsViewModel(
        client: APIEnvironment.shared.searchClient
    )

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 16) {
                Text(routeString)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                if viewModel.isLoading {
                    ProgressView("Загрузка вариантов...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorText = viewModel.errorText {
                    ErrorScreenView(errorType: .serverError, customText: errorText)
                } else if viewModel.filteredCarriers.isEmpty {
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredCarriers) { carrier in
                            Button {
                                path.append(Route.carrierInfo)
                            } label: {
                                CarrierCardView(carrier: carrier)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 0,
                                    leading: 16,
                                    bottom: 8,
                                    trailing: 16
                                )
                            )
                        }
                    }
                    .listStyle(.plain)
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 80)
                    }
                    .padding(.bottom, 24)
                }
            }

            let isDefaultFilters = viewModel.timeSelection.isEmpty && ((viewModel.showTransfers ?? true) == true)
            let shouldShowFiltersButton = !viewModel.isLoading && viewModel.errorText == nil && (!viewModel.filteredCarriers.isEmpty || !isDefaultFilters)

            if shouldShowFiltersButton {
                NavigationLink {
                    FiltersView(
                        timeSelection: $viewModel.timeSelection,
                        showTransfers: $viewModel.showTransfers
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
                } label: {
                    HStack(spacing: 4) {
                        Text("Уточнить время")

                        if !viewModel.timeSelection.isEmpty {
                            Circle()
                                .fill(Color.redUniversal)
                                .frame(width: 8, height: 8)
                        }
                    }
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
        .task {
            await viewModel.search(
                fromCode: fromStation.id,
                toCode: toStation.id,
                transfers: viewModel.showTransfers ?? true
            )
        }
        .onChange(of: viewModel.showTransfers) { _, newValue in
            Task {
                await viewModel.search(
                    fromCode: fromStation.id,
                    toCode: toStation.id,
                    transfers: newValue ?? true
                )
            }
        }
        .overlay(alignment: .leading) {
            Color.clear
                .frame(width: 24)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.width > 80 && abs(value.translation.height) < 40 {
                                if !path.isEmpty {
                                    path.removeLast()
                                }
                            }
                        }
                )
        }
    }

}
