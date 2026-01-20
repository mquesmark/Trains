import SwiftUI

/// Этот экран намеренно реализован без ViewModel.
/// "FiltersView" редактирует состояние родительского экрана через @Binding (применение логики остаётся снаружи),
/// поэтому отдельная ViewModel здесь привела бы к дублированию состояния и риску рассинхронизации.

struct FiltersView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Bindings

    @Binding var timeSelection: Set<TimeIntervals>
    @Binding var showTransfers: Bool

    // MARK: - Draft State

    @State private var draftTimeSelection: Set<TimeIntervals>
    @State private var draftShowTransfers: Bool

    // MARK: - Init

    init(
        timeSelection: Binding<Set<TimeIntervals>>,
        showTransfers: Binding<Bool>
    ) {
        self._timeSelection = timeSelection
        self._showTransfers = showTransfers
        self._draftTimeSelection = State(initialValue: timeSelection.wrappedValue)
        self._draftShowTransfers = State(initialValue: showTransfers.wrappedValue)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
    }

    // MARK: - Layout

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
        VStack(spacing: 0) {
            ForEach(TimeIntervals.allCases, id: \.self) { interval in
                timeRow(interval)
            }
        }
        .background(Color.backgroundYP)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func timeRow(_ interval: TimeIntervals) -> some View {
        HStack {
            Text(interval.title)
            Spacer()
            Image(
                systemName: draftTimeSelection.contains(interval)
                ? "checkmark.square.fill"
                : "square"
            )
            .font(.system(size: 20, weight: .semibold))
        }
        .frame(height: 60)
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            if draftTimeSelection.contains(interval) {
                draftTimeSelection.remove(interval)
            } else {
                draftTimeSelection.insert(interval)
            }
        }
    }

    // MARK: - Transfers Filter

    private var transfersTitleView: some View {
        Text("Показывать варианты с пересадками")
            .font(.system(size: 24, weight: .bold))
    }

    private var transfersListView: some View {
        VStack(spacing: 0) {
            transferRow(title: "Да", isSelected: draftShowTransfers == true) {
                draftShowTransfers = true
            }
            transferRow(title: "Нет", isSelected: draftShowTransfers == false) {
                draftShowTransfers = false
            }
        }
        .background(Color.backgroundYP)
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
        .padding(.horizontal, 8)
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

    private func applyTapped() {
        timeSelection = draftTimeSelection
        showTransfers = draftShowTransfers
        dismiss()
    }
}
