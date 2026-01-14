import Foundation
import Combine

@MainActor
final class CarriersResultsViewModel: ObservableObject {
    
    let allCarriers: [CarrierCardModel] = Mocks.mockCarrierCards
    
    @Published var timeSelection: Set<TimeIntervals> = []
    @Published var showTransfers: Bool? = nil
    
    var filteredCarriers: [CarrierCardModel] {
        allCarriers
    }
    var isCarriersListEmpty: Bool {
        filteredCarriers.isEmpty
    }
    
    
}
