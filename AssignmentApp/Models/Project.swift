import Foundation
//Project struct, containing all properties needed by the database.
struct Project : Codable, Identifiable{
    let id: Int
    let name: String
    let description: String
    let start_date: String
    let end_date: String
    let user_id: Int
}
