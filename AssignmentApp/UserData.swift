//Class that stores the current user that is logged in.
class UserData{
    static let shared = UserData()
    var currentUser: User? = nil
}
