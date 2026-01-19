import Foundation

struct CarrierCardModel: Identifiable {
    let id = UUID()
    
    let date: String
    let startTime: String
    let endTime: String
    let routeTime: String
    var warningText: String?
    let transferCity: String?
    
    let carrierInfo: CarrierInfo
    
    init(date: String, startTime: String, endTime: String, routeTime: String, warningText: String? = nil, transferCity: String? = nil, carrierInfo: CarrierInfo) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.routeTime = routeTime
        self.warningText = warningText
        self.transferCity = transferCity
        self.carrierInfo = carrierInfo
    }
}
