import SwiftUI

/// Этот экран намеренно реализован без ViewModel.
/// "FiltersView" редактирует состояние родительского экрана через @Binding (применение логики остаётся снаружи),
/// поэтому отдельная ViewModel здесь привела бы к дублированию состояния и риску рассинхронизации.

struct FiltersView: View {

    @Environment(\.dismiss) private var dismiss

    @Binding var timeSelection: Set<TimeIntervals>
    @Binding var showTransfers: Bool?

    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 80 && abs(value.translation.height) < 40 {
                        dismiss()
                    }
                }
        )
    }

    // MARK: - Content

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            timeTitleView
            timeListView
            transfersTitleView
            transfersListView
            Spacer()
            applyButton
        }
        .padding(16)
    }

    // MARK: - Background

    private var backgroundView: some View {
        Color.backgroundYP
            .ignoresSafeArea()
    }

    // MARK: - Time Filter

    private var timeTitleView: some View {
        Text("Время отправления")
            .font(.system(size: 24, weight: .bold))
    }

    private var timeListView: some View {
        List(TimeIntervals.allCases, id: \.self) { interval in
            timeRow(interval)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundYP)
        .frame(maxHeight: CGFloat(60 * TimeIntervals.allCases.count))
    }

    private func timeRow(_ interval: TimeIntervals) -> some View {
        HStack {
            Text(interval.title)
            Spacer()
            Image(
                systemName: timeSelection.contains(interval)
                ? "checkmark.square.fill"
                : "square"
            )
            .font(.system(size: 20, weight: .semibold))
        }
        .frame(height: 60)
        .listRowBackground(Color.backgroundYP)
        .listRowInsets(.init(.zero))
        .listRowSeparator(.hidden)
        .contentShape(Rectangle())
        .onTapGesture {
            toggleTimeSelection(interval)
        }
    }

    // MARK: - Transfers Filter

    private var transfersTitleView: some View {
        Text("Показывать варианты с пересадками")
            .font(.system(size: 24, weight: .bold))
    }

    private var transfersListView: some View {
        List {
            transferRow(title: "Да", isSelected: showTransfers == true) {
                showTransfers = true
            }

            transferRow(title: "Нет", isSelected: showTransfers == false) {
                showTransfers = false
            }
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundYP)
        .frame(maxHeight: 120)
    }

    private func transferRow(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            Image(isSelected ? .circleSelected : .circle)
        }
        .frame(height: 60)
        .listRowBackground(Color.backgroundYP)
        .listRowInsets(.init(.zero))
        .listRowSeparator(.hidden)
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }

    // MARK: - Apply Button

    private var applyButton: some View {
        Button(action: applyTapped) {
            Text("Применить")
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blueUniversal)
                )
                .contentShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Actions

    private func toggleTimeSelection(_ interval: TimeIntervals) {
        if timeSelection.contains(interval) {
            timeSelection.remove(interval)
        } else {
            timeSelection.insert(interval)
        }
    }

    private func applyTapped() {
        dismiss()
    }
}

