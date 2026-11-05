import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let specialCharacters = "!@#$%&*()_+-=?¿¡/\\|<>[]{}:'\""

    /// true si algún campo está vacío (se usa en .disabled)
    var isFormEmpty: Bool {
        name.trimmingCharacters(in: .whitespaces).isEmpty
        || email.trimmingCharacters(in: .whitespaces).isEmpty
        || password.isEmpty
        || confirmPassword.isEmpty
    }

    private func isValidEmail(_ value: String) -> Bool {
        let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,}$"
        return value.range(of: pattern, options: .regularExpression) != nil
    }

    private func validate(with session: SessionStore) -> Bool {
        let cleanName = name.trimmingCharacters(in: .whitespaces)
        let cleanEmail = email.trimmingCharacters(in: .whitespaces)

        guard !cleanName.isEmpty, !cleanEmail.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Completa todos los campos."
            return false
        }
        guard isValidEmail(cleanEmail) else {
            errorMessage = "Ingresa un correo electrónico válido."
            return false
        }
        guard !session.emailExists(cleanEmail) else {
            errorMessage = "Este correo ya está registrado."
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
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden."
            return false
        }

        errorMessage = nil
        return true
    }

    /// Valida, guarda el usuario, muestra "Cuenta creada" y luego entra al Home.
    @MainActor
    func register(with session: SessionStore) async {
        guard successMessage == nil, validate(with: session) else { return }

        let user = User(
            name: name.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            password: password
        )

        guard session.register(user) else {
            errorMessage = "Este correo ya está registrado."
            return
        }

        successMessage = "Cuenta creada"
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        session.login(user)   // RootView cambia automáticamente al Home
    }
}
