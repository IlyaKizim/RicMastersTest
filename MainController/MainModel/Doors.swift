
import Foundation

struct APIDoors: Codable {
    let success: Bool?
    let data: [Door]
}

struct Door: Codable {
    var name: String?
    var room: String?
    var id: Int?
    var favorites: Bool?
    var snapshot: String?
    var isLocked: Bool?
    var addedStar: Bool?
}
