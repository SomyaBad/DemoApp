
import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releasedate: String?
    let releaseDate : String?
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releasedate
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
