import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?

    // Variables temporales: solo se llenan cuando los datos son válidos
    private(set) var validEmail = ""
    private(set) var validPassword = ""

    // Caracteres especiales aceptados (sin puntos, comas, punto y coma ni tildes)
    private let specialCharacters = "!@#$%&*()_+-=?¿¡/\\|<>[]{}:'\""

    /// true si algún campo está vacío (se usa en .disabled)
    var isFormEmpty: Bool {
        email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty
    }

    private func isValidEmail(_ value: String) -> Bool {
        let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,}$"
        return value.range(of: pattern, options: .regularExpression) != nil
    }

    func validate() -> Bool {
        let cleanEmail = email.trimmingCharacters(in: .whitespaces)

        guard isValidEmail(cleanEmail) else {
            errorMessage = "Ingresa un correo electrónico válido."
            return false
        }
        guard password.count >= 6 else {
            errorMessage = "La contraseña debe tener al menos 6 caracteres."
            return false
        }
        guard password.range(of: "[A-Z]", options: .regularExpression) != nil else {
            errorMessage = "La contraseña debe incluir al menos una mayúscula."
            return false
        }
        guard password.contains(where: { specialCharacters.contains($0) }) else {
            errorMessage = "La contraseña debe incluir un carácter especial (por ejemplo ! @ # $ %). No se aceptan puntos, comas, punto y coma ni tildes."
            return false
        }

        // Datos válidos: se guardan temporalmente
        validEmail = cleanEmail
        validPassword = password
        errorMessage = nil
        return true
    }

    func login(with session: SessionStore) {
        guard validate() else { return }

        if let user = session.authenticate(email: validEmail, password: validPassword) {
            session.login(user)
        } else {
            errorMessage = "Correo o contraseña incorrectos."
        }
    }
}
