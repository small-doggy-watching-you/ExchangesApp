
import Foundation

struct Currency: Codable {
    let timeLastUpdateUtc: Date
    let timeNextUpdateUtc: Date
    let baseCode: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case timeLastUpdateUtc = "time_last_update_utc"
        case timeNextUpdateUtc = "time_next_update_utc"
        case baseCode = "base_code"
        case rates
    }
}
