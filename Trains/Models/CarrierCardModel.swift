import Foundation

struct CarrierCardModel: Identifiable, Sendable {
    let id = UUID()
    
    let departureDate: Date
    let arrivalDate: Date
    
    let date: String
    let startTime: String
    let endTime: String
    let routeTime: String
    var warningText: String?
    let transferCity: String?
    
    let carrierInfo: CarrierInfo
    
    init(departureDate: Date, arrivalDate: Date, date: String, startTime: String, endTime: String, routeTime: String, warningText: String? = nil, transferCity: String? = nil, carrierInfo: CarrierInfo) {
        self.date = date
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.startTime = startTime
        self.endTime = endTime
        self.routeTime = routeTime
        self.warningText = warningText
        self.transferCity = transferCity
        self.carrierInfo = carrierInfo
    }
}
