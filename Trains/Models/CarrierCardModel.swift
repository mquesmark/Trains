import Foundation

struct CarrierCardModel: Identifiable {
    let id = UUID()
    
    let date: String
    let startTime: String
    let endTime: String
    let routeTime: String
    let logo: String
    let name: String
    var warningText: String?
    let transferCity: String?
    
    let carrierInfo: CarrierInfo
    
    init(date: String, startTime: String, endTime: String, routeTime: String, logo: String, name: String, warningText: String? = nil, transferCity: String? = nil, carrierInfo: CarrierInfo = Mocks.carrierInfo) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.routeTime = routeTime
        self.logo = logo
        self.name = name
        self.warningText = warningText
        self.transferCity = transferCity
        self.carrierInfo = carrierInfo
    }
}
