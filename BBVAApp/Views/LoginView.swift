import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = LoginViewModel()

    @State private var showMenu = false
    @State private var goRegister = false

    private let panelColor = Color(hex: "#050F26")

    /// Saludo según la hora, como en la app real.
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Buenos días"
        case 12..<19: return "Buenas tardes"
        default: return "Buenas noches"
        }
    }

    var body: some View {
        ZStack {
            LoginBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    topBar

                    loginCard
                        .padding(.horizontal, 14)
                        .padding(.top, 90)

                    openAccountSection
                        .padding(.top, 28)
                }
            }
            .scrollDismissesKeyboard(.interactively)

            if showMenu {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) { showMenu = false }
                    }
                    .transition(.opacity)
                    .zIndex(1)

                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    sideMenu
                }
                .transition(.move(edge: .trailing))
                .zIndex(2)
            }
        }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $goRegister) {
            RegisterView()
        }
    }

    // Logo centrado y botón de menú a la derecha.
    private var topBar: some View {
        ZStack {
            Image("bbva_logo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 110)
                .foregroundStyle(.white)

            HStack {
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { showMenu = true }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(BBVAColor.lightBlue)
                            .frame(width: 40, height: 40)
                            .background(BBVAColor.navy, in: Circle())

                        Text("Menú")
                            .font(.custom("AvenirNext-Medium", size: 12))
                            .foregroundStyle(BBVAColor.lightBlue)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // Menú lateral que se abre desde la derecha (como en la app real).
    private var sideMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 34) {
                menuLink(icon: "lock", title: "Seguridad y privacidad", url: "https://www.bbva.pe")
                menuLink(icon: "mappin.and.ellipse", title: "Puntos de atención", url: "https://www.bbva.pe")
                menuLink(icon: "phone", title: "Comunícate con nosotros", url: "https://www.bbva.pe")
                menuLink(icon: "square.grid.2x2", title: "Aplicaciones", url: "https://www.bbva.pe")

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { showMenu = false }
                    goRegister = true
                } label: {
                    menuLabel(icon: "person.badge.plus", title: "Hazte cliente")
                }

                menuLink(icon: "info.circle", title: "Acerca de BBVA", url: "https://www.bbva.pe")
            }
            .padding(.top, 70)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.25)) { showMenu = false }
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "chevron.right.circle")
                        .font(.system(size: 22))
                    Text("Iniciar sesión")
                        .font(.custom("AvenirNext-DemiBold", size: 17))
                }
                .foregroundStyle(Color(hex: "#F5C24B"))
            }
            .padding(.bottom, 50)
        }
        .padding(.horizontal, 28)
        .frame(width: UIScreen.main.bounds.width * 0.74)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(Color(hex: "#020817").ignoresSafeArea())
    }

    private func menuLabel(icon: String, title: String) -> some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 28)
            Text(title)
                .font(.custom("AvenirNext-DemiBold", size: 17))
                .multilineTextAlignment(.leading)
        }
        .foregroundStyle(BBVAColor.lightBlue)
    }

    private func menuLink(icon: String, title: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            menuLabel(icon: icon, title: title)
        }
    }

    // Tarjeta oscura: saludo, campos, botón, registro y accesos rápidos.
    private var loginCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(greeting)
                .font(.custom("Georgia-Bold", size: 34))
                .foregroundStyle(.white)

            VStack(spacing: 22) {
                BBVAInputField(
                    title: "Correo electrónico",
                    text: $viewModel.email,
                    keyboard: .emailAddress,
                    onDark: true
                )

                BBVAInputField(
                    title: "Contraseña",
                    text: $viewModel.password,
                    isSecure: true,
                    onDark: true
                )
            }
            .padding(.top, 24)

            if let message = viewModel.errorMessage {
                Text(message)
                    .font(.custom("AvenirNext-Regular", size: 14))
                    .foregroundStyle(BBVAColor.error)
                    .padding(.top, 14)
            }

            Button("Iniciar sesión") {
                viewModel.login(with: session)
            }
            .buttonStyle(BBVALightButtonStyle())
            .disabled(viewModel.isFormEmpty)
            .padding(.top, 24)

            Text("¿Eres cliente y es tu primera vez en la app?")
                .font(.custom("AvenirNext-Regular", size: 16))
                .foregroundStyle(.white)
                .padding(.top, 22)

            NavigationLink {
                RegisterView()
            } label: {
                Text("Regístrate")
                    .font(.custom("AvenirNext-Medium", size: 17))
                    .foregroundStyle(BBVAColor.lightBlue)
            }
            .padding(.top, 8)

            HStack(alignment: .top, spacing: 8) {
                NavigationLink {
                    RegisterView()
                } label: {
                    quickAction(icon: "person.crop.circle.badge.plus", title: "Hazte cliente")
                }
                .buttonStyle(.plain)

                Link(destination: URL(string: "https://www.bbva.pe")!) {
                    quickAction(icon: "mappin.and.ellipse", title: "Puntos de atención")
                }

                Link(destination: URL(string: "https://www.bbva.pe")!) {
                    quickAction(icon: "phone.fill", title: "Contáctanos")
                }
            }
            .padding(.top, 30)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BBVAColor.navy.opacity(0.82), in: RoundedRectangle(cornerRadius: 20))
    }

    private func quickAction(icon: String, title: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(BBVAColor.lightBlue)
                .frame(width: 56, height: 56)
                .background(Color.black.opacity(0.35), in: Circle())

            Text(title)
                .font(.custom("AvenirNext-Medium", size: 14))
                .foregroundStyle(BBVAColor.lightBlue)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }

    // Sección oscura inferior: "Abre tu Cuenta BBVA".
    private var openAccountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Abre tu Cuenta BBVA")
                .font(.custom("Georgia-Bold", size: 26))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [BBVAColor.coreBlue, BBVAColor.aqua],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .frame(height: 180)

                Text("¿Sin una Cuenta BBVA?")
                    .font(.custom("AvenirNext-Bold", size: 24))
                    .foregroundStyle(.white)
                    .padding(.top, 8)

                Text("Elige la ideal para ti y ábrela desde nuestra web")
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .foregroundStyle(.white.opacity(0.6))

                Link(destination: URL(string: "https://www.bbva.pe")!) {
                    Text("Conocer más")
                        .font(.custom("AvenirNext-DemiBold", size: 17))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(BBVAColor.coreBlue, in: RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, 8)
            }
            .padding(14)
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 20))
        }
        .padding(.horizontal, 14)
        .padding(.top, 24)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            TopRoundedShape(radius: 28)
                .fill(panelColor)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

/// Fondo: usa la foto "login_bg" de Assets (mar visto desde arriba) con un oscurecido azul;
/// si no existe, un degradado marino con los colores BBVA.
private struct LoginBackground: View {
    var body: some View {
        if UIImage(named: "login_bg") != nil {
            ZStack {
                Color.clear
                    .overlay(
                        Image("login_bg")
                            .resizable()
                            .scaledToFill()
                    )
                    .clipped()

                LinearGradient(
                    colors: [BBVAColor.navy.opacity(0.25), BBVAColor.navy.opacity(0.75)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        } else {
            ZStack {
                LinearGradient(
                    colors: [BBVAColor.navy, BBVAColor.blue],
                    startPoint: .top,
                    endPoint: .bottom
                )
                RadialGradient(
                    colors: [BBVAColor.aqua.opacity(0.75), .clear],
                    center: UnitPoint(x: 0.45, y: 0.12),
                    startRadius: 0,
                    endRadius: 320
                )
                RadialGradient(
                    colors: [BBVAColor.coreBlue.opacity(0.6), .clear],
                    center: UnitPoint(x: 0.9, y: 0.3),
                    startRadius: 0,
                    endRadius: 300
                )
            }
        }
    }
}

/// Rectángulo con solo las esquinas superiores redondeadas.
private struct TopRoundedShape: Shape {
    var radius: CGFloat = 28

    func path(in rect: CGRect) -> Path {
        Path(
            UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        )
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environmentObject(SessionStore())
}
