import Foundation
//Task struct, containing all properties needed by the database.
struct Task: Codable, Identifiable {
    let id : Int
    let name : String
    let description: String
    let due_date : String
    let status : String
    let project_id: Int
}
