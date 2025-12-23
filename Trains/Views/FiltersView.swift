import SwiftUI

enum TimeIntervals: CaseIterable {
    case morning
    case day
    case evening
    case night
    
    var title: String {
        switch self {
        case .morning: return "Утро 06:00 – 12:00"
        case .day: return "День 12:00 – 18:00"
        case .evening: return "Вечер 18:00 – 00:00"
        case .night: return "Ночь 00:00 – 06:00"
        }
    }
}

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var timeSelection: Set<TimeIntervals>
    @Binding var showTransfers: Bool?
    
    var body: some View {
        ZStack {
            Color.backgroundYP
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                
                List(TimeIntervals.allCases, id: \.self) { interval in
                    HStack {
                        Text(interval.title)
                        Spacer()
                        Image(systemName: timeSelection.contains(interval) ? "checkmark.square.fill" : "square")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .frame(height: 60)
                    .listRowBackground(Color.backgroundYP)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleTimeSelection(interval)
                    }
                }
                .scrollDisabled(true)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.backgroundYP)
                .frame(maxHeight: CGFloat(60 * TimeIntervals.allCases.count))
                
                Text("Показывать варианты с пересадками")
                    .font(.system(size: 24, weight: .bold))
                
                List {
                    Group {
                        HStack {
                            Text("Да")
                            Spacer()
                            Image((showTransfers ?? false) ? .circleSelected : .circle)
                        }
                        .frame(height: 60)
                        .listRowSeparator(.hidden)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showTransfers = true
                        }
                        HStack {
                            Text("Нет")
                            Spacer()
                            Image(((showTransfers != nil) && showTransfers == false) ? .circleSelected : .circle)
                        }
                        .frame(height: 60)
                        .listRowSeparator(.hidden)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showTransfers = false
                        }
                    }
                    .listRowBackground(Color.backgroundYP)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .scrollDisabled(true)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.backgroundYP)
                .frame(maxHeight: CGFloat(60 * 2))
                
                Spacer()
                
                Button {
                    applyTapped()
                } label: {
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
            .padding(16)
        }
    }
    
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
