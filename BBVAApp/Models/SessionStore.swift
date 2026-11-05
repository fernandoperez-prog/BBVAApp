import SwiftUI

/// Estado compartido de la sesión. Se inyecta una vez como @EnvironmentObject.
final class SessionStore: ObservableObject {
    // Usuario de prueba para poder ingresar
    @Published private(set) var users: [User] = [
        User(name: "Cliente Demo", email: "demo@bbva.pe", password: "Bbva@2026")
    ]
    @Published private(set) var currentUser: User?

    private func normalized(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    func emailExists(_ email: String) -> Bool {
        let target = normalized(email)
        return users.contains { normalized($0.email) == target }
    }

    /// Agrega el usuario a la lista en memoria. No inicia sesión.
    @discardableResult
    func register(_ user: User) -> Bool {
        guard !emailExists(user.email) else { return false }
        users.append(user)
        return true
    }

    func authenticate(email: String, password: String) -> User? {
        let target = normalized(email)
        return users.first { normalized($0.email) == target && $0.password == password }
    }

    func login(_ user: User) {
        currentUser = user
    }

    func logout() {
        currentUser = nil
    }
}
