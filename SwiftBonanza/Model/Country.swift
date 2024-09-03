
import Foundation

struct CountryData: Codable {
    let success, hasNext: Bool
    let total: Int
    let data: [Country]

    enum CodingKeys: String, CodingKey {
        case success
        case hasNext = "has_next"
        case total, data
    }
}

struct Country: Codable {
    let id: Int
    let name: String
}

