struct CarrierInfo: Hashable {
    let code: String?
    let imageUrlString: String
    let name: String
    let email: String
    let phone: String
    
    init(code: String? = nil, imageUrlString: String, name: String, email: String, phone: String) {
        self.code = code
        self.imageUrlString = imageUrlString
        self.name = name
        self.email = email
        self.phone = phone
    }
}
