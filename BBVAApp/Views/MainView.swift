import SwiftUI

/// Pestañas de la barra inferior (como en la referencia: inicio, salud, contratar, mensajes).
enum MainTab: CaseIterable {
    case home, health, contract, messages

    var icon: String {
        switch self {
        case .home: return "house"
        case .health: return "waveform.path.ecg"
        case .contract: return "plus.circle"
        case .messages: return "envelope"
        }
    }

    var activeIcon: String {
        switch self {
        case .home: return "house.fill"
        case .health: return "waveform.path.ecg"
        case .contract: return "plus.circle.fill"
        case .messages: return "envelope.fill"
        }
    }

    var title: String {
        switch self {
        case .home: return "Inicio"
        case .health: return "Salud financiera"
        case .contract: return "Contratar"
        case .messages: return "Mensajes"
        }
    }
}

/// Contenedor principal: contenido arriba y barra de navegación inferior.
struct MainView: View {
    @State private var selected: MainTab = .home

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selected {
                case .home:
                    HomeView()
                default:
                    PlaceholderTabView(tab: selected)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomTabBar(selected: $selected)
        }
        .background(BBVAColor.background.ignoresSafeArea())
    }
}

struct BottomTabBar: View {
    @Binding var selected: MainTab

    var body: some View {
        HStack {
            ForEach(MainTab.allCases, id: \.self) { tab in
                Button {
                    selected = tab
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: selected == tab ? tab.activeIcon : tab.icon)
                            .font(.system(size: 22))

                        Circle()
                            .fill(selected == tab ? BBVAColor.coreBlue : Color.clear)
                            .frame(width: 5, height: 5)
                    }
                    .foregroundStyle(selected == tab ? BBVAColor.blue : BBVAColor.navy.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 6)
        .background(
            Color.white
                .ignoresSafeArea(edges: .bottom)
                .shadow(color: BBVAColor.navy.opacity(0.10), radius: 8, y: -3)
        )
    }
}

/// Pantalla simple para las pestañas que aún no tienen contenido.
private struct PlaceholderTabView: View {
    let tab: MainTab

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: tab.activeIcon)
                .font(.system(size: 44))
                .foregroundStyle(BBVAColor.coreBlue)

            Text(tab.title)
                .font(.custom("AvenirNext-Bold", size: 24))
                .foregroundStyle(BBVAColor.blue)

            Text("Esta sección estará disponible pronto.")
                .font(.custom("AvenirNext-Regular", size: 15))
                .foregroundStyle(BBVAColor.navy.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BBVAColor.background.ignoresSafeArea())
    }
}

#Preview {
    MainView()
        .environmentObject({
            let session = SessionStore()
            session.login(User(name: "Cliente Demo", email: "demo@bbva.pe", password: "Bbva@2026"))
            return session
        }())
}
