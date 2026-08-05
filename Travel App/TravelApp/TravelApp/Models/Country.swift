import Foundation

struct Country: Identifiable, Codable, Hashable {
    let id: UUID = UUID()
    let name: String
    let monumentName: String
    let monumentImage: String // can be URL or sf: symbol prefix
    let countryDescription: String
    let monumentDescription: String
}
