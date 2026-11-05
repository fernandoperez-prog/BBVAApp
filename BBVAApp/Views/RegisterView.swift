import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var session: SessionStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                topBar

                Text("Crea tu cuenta")
                    .font(.custom("AvenirNext-Bold", size: 32))
                    .foregroundStyle(BBVAColor.blue)
                    .padding(.top, 32)

                Text("Solo te tomará un minuto")
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .foregroundStyle(BBVAColor.navy.opacity(0.55))
                    .padding(.top, 2)

                VStack(spacing: 28) {
                    BBVAInputField(
                        title: "Nombre completo",
                        text: $viewModel.name,
                        capitalization: .words
                    )

                    BBVAInputField(
                        title: "Correo electrónico",
                        text: $viewModel.email,
                        keyboard: .emailAddress
                    )

                    BBVAInputField(
                        title: "Contraseña",
                        text: $viewModel.password,
                        isSecure: true
                    )

                    BBVAInputField(
                        title: "Confirmar contraseña",
                        text: $viewModel.confirmPassword,
                        isSecure: true
                    )
                }
                .padding(.top, 32)

                if let message = viewModel.errorMessage {
                    Text(message)
                        .font(.custom("AvenirNext-Regular", size: 14))
                        .foregroundStyle(BBVAColor.error)
                        .padding(.top, 16)
                }

                if let success = viewModel.successMessage {
                    Label(success, systemImage: "checkmark.circle.fill")
                        .font(.custom("AvenirNext-DemiBold", size: 16))
                        .foregroundStyle(BBVAColor.success)
                        .padding(.top, 16)
                }

                Button("Crear cuenta") {
                    Task { await viewModel.register(with: session) }
                }
                .buttonStyle(BBVAButtonStyle())
                .disabled(viewModel.isFormEmpty || viewModel.successMessage != nil)
                .padding(.top, 32)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 32)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    // Flecha atrás a la izquierda y logo azul centrado.
    private var topBar: some View {
        ZStack {
            Image("bbva_logo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .foregroundStyle(BBVAColor.blue)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(BBVAColor.blue)
                }
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
    .environmentObject(SessionStore())
}
