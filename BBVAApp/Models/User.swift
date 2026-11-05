import Foundation

struct User: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var email: String
    var password: String
}
