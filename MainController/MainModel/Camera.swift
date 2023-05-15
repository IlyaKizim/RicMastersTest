
import Foundation

struct ApiResponse: Codable {
    let success: Bool?
    let data: ApiData
}

struct ApiData: Codable {
    let room: [String]
    let cameras: [Camera]
}

struct Camera: Codable {
    let name: String?
    let snapshot: String?
    let room: String?
    let id: Int?
    let favorites: Bool?
    let rec: Bool?
    var addedStar: Bool?
}
