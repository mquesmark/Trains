import Foundation
import Combine

@MainActor
final class CarrierInfoViewModel: ObservableObject {
    @Published var carrierName: String
    @Published var carrierInfo: CarrierInfo = Mocks.carrierInfo
    
    init(carrierName: String) {
        self.carrierName = carrierName
    }
    
}
