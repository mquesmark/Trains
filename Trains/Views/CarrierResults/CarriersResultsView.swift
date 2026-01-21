import SwiftUI

struct CarriersResultsView: View {
    @Binding var path: NavigationPath
    let fromStation: Station
    let fromCity: City
    let toStation: Station
    let toCity: City

    var routeString: String {
        "\(fromCity.title) (\(fromStation.title)) → \(toCity.title) (\(toStation.title))"
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
                    CarrierLoadingSkeletonView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                } else if let errorText = viewModel.errorText {
                    ErrorScreenView(
                        errorType: .serverError,
                        customText: errorText
                    )
                } else if viewModel.filteredCarriers.isEmpty {
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredCarriers) { carrier in
                            Button {
                                path.append(
                                    Route.carrierInfo(carrier.carrierInfo)
                                )
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

            let isDefaultFilters =
                viewModel.timeSelection.isEmpty
                && ((viewModel.showTransfers) == true)
            let shouldShowFiltersButton =
                !viewModel.isLoading && viewModel.errorText == nil
                && (!viewModel.filteredCarriers.isEmpty || !isDefaultFilters)

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
        .task(
            id:
                "\(fromStation.id)|\(toStation.id)|\((viewModel.showTransfers) ? 1 : 0)"
        ) {
            await viewModel.search(
                fromCode: fromStation.id,
                toCode: toStation.id,
                transfers: viewModel.showTransfers
            )
        }
        .overlay(alignment: .leading) {
            Color.clear
                .frame(width: 24)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.width > 80
                                && abs(value.translation.height) < 40
                            {
                                if !path.isEmpty {
                                    path.removeLast()
                                }
                            }
                        }
                )
        }
    }

    // MARK: - Skeleton Loading Views

    private struct CarrierLoadingSkeletonView: View {
        private let itemsCount: Int = 6

        var body: some View {
            VStack(spacing: 0) {
                ForEach(0..<itemsCount, id: \.self) { _ in
                    CarrierSkeletonCardView()
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundYP)
            .accessibilityHidden(true)
        }
    }

    private struct CarrierSkeletonCardView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 220, height: 16)

                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 70, height: 16)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 90, height: 16)

                    Spacer()

                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 60, height: 16)
                }

                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 150, height: 16)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .shimmer()
        }
    }

}
