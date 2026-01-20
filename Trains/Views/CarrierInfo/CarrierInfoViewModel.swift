import Combine
import Foundation

@MainActor
final class CarrierInfoViewModel: ObservableObject {
    @Published var carrierInfo: CarrierInfo

    init(carrierInfo: CarrierInfo) {
        self.carrierInfo = carrierInfo
    }
}
