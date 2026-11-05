import SwiftUI

private struct AccountSummary: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let balance: String
}

private struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
}

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = HomeViewModel()

    private let accounts = [
        AccountSummary(name: "Cuenta de Ahorros", number: "*37265", balance: "S/ 20,000.00"),
        AccountSummary(name: "Cuenta Sueldo", number: "*36264", balance: "S/ 8,450.00")
    ]

    private let quickActions = [
        QuickAction(title: "Oportunidades", icon: "plus", color: Color(hex: "#F5883A")),
        QuickAction(title: "Transferir", icon: "arrow.left.arrow.right", color: Color(hex: "#4FA8D6")),
        QuickAction(title: "Retiro sin tarjeta", icon: "dollarsign", color: Color(hex: "#3DCB6B")),
        QuickAction(title: "Pagar servicios", icon: "bolt.fill", color: Color(hex: "#7C5CD6"))
    ]

    private let cardNumbers = ["*6239", "*4410"]

    private var firstName: String {
        session.currentUser?.name.split(separator: " ").first.map(String.init) ?? ""
    }

    private var initial: String {
        String(firstName.prefix(1)).uppercased()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    header

                    accountsCard
                        .padding(.horizontal, 16)
                        .padding(.top, -44)

                    quickActionsRow
                        .padding(.top, 22)

                    cardsSection
                        .padding(.horizontal, 16)
                        .padding(.top, 22)

                    productsCard
                        .padding(.horizontal, 16)
                        .padding(.top, 22)
                        .padding(.bottom, 24)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .background(BBVAColor.background.ignoresSafeArea())
            .navigationDestination(for: ItemModel.self) { item in
                DetailView(item: item)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(.white)
    }

    // Cabecera azul: salir a la izquierda, saludo al centro, inicial del usuario a la derecha.
    private var header: some View {
        HStack {
            Button {
                session.logout()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40, alignment: .leading)
            }

            Spacer()

            Text("Hola, \(firstName)")
                .font(.custom("AvenirNext-Bold", size: 18))
                .foregroundStyle(.white)

            Spacer()

            Text(initial)
                .font(.custom("AvenirNext-Bold", size: 16))
                .foregroundStyle(BBVAColor.blue)
                .frame(width: 40, height: 40)
                .background(.white, in: Circle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 72)
        .background(BBVAColor.blue.ignoresSafeArea(edges: .top))
    }

    // Tarjeta blanca superpuesta a la cabecera: cuentas.
    private var accountsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TUS CUENTAS")
                .font(.custom("AvenirNext-DemiBold", size: 13))
                .foregroundStyle(BBVAColor.navy)
                .padding(.bottom, 6)

            ForEach(accounts) { account in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(account.name)
                            .font(.custom("AvenirNext-DemiBold", size: 16))
                            .foregroundStyle(BBVAColor.coreBlue)
                        Text(account.number)
                            .font(.custom("AvenirNext-Regular", size: 12))
                            .foregroundStyle(BBVAColor.navy.opacity(0.55))
                    }

                    Spacer()

                    Text(account.balance)
                        .font(.custom("AvenirNext-DemiBold", size: 16))
                        .foregroundStyle(BBVAColor.blue)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(BBVAColor.navy.opacity(0.3))
                }
                .padding(.vertical, 12)

                if account.id != accounts.last?.id {
                    Divider()
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: BBVAColor.navy.opacity(0.08), radius: 10, y: 4)
    }

    // Fila de accesos rápidos con círculos de colores.
    private var quickActionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 18) {
                ForEach(quickActions) { action in
                    VStack(spacing: 8) {
                        Image(systemName: action.icon)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 58, height: 58)
                            .background(action.color, in: Circle())

                        Text(action.title)
                            .font(.custom("AvenirNext-Medium", size: 11))
                            .foregroundStyle(BBVAColor.navy.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .frame(width: 74)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // Tarjetas azules con logo, chip y VISA.
    private var cardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TUS TARJETAS")
                .font(.custom("AvenirNext-DemiBold", size: 13))
                .foregroundStyle(BBVAColor.navy)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(cardNumbers, id: \.self) { number in
                        VStack(alignment: .leading, spacing: 8) {
                            creditCard(number: number)

                            HStack(spacing: 6) {
                                Image(systemName: "creditcard")
                                    .font(.system(size: 11))
                                Text("Tarjeta digital")
                                    .font(.custom("AvenirNext-Regular", size: 11))
                            }
                            .foregroundStyle(BBVAColor.navy.opacity(0.6))
                        }
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: BBVAColor.navy.opacity(0.08), radius: 10, y: 4)
    }

    private func creditCard(number: String) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(BBVAColor.blue)

            VStack(alignment: .leading, spacing: 0) {
                Image("bbva_logo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46)
                    .foregroundStyle(.white)

                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(hex: "#F2C46D"))
                    .frame(width: 24, height: 17)
                    .padding(.top, 8)

                Spacer()

                HStack {
                    Text(number)
                        .font(.custom("AvenirNext-DemiBold", size: 13))
                        .foregroundStyle(.white)
                    Spacer()
                    Text("VISA")
                        .font(.system(size: 17, weight: .heavy).italic())
                        .foregroundStyle(.white)
                }
            }
            .padding(14)
        }
        .frame(width: 220, height: 130)
    }

    // Tarjeta blanca: buscador + lista de productos.
    private var productsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TUS PRODUCTOS")
                .font(.custom("AvenirNext-DemiBold", size: 13))
                .foregroundStyle(BBVAColor.navy)

            searchField

            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredItems) { item in
                    NavigationLink(value: item) {
                        ItemRow(item: item)
                    }
                    .buttonStyle(.plain)

                    if item.id != viewModel.filteredItems.last?.id {
                        Divider().padding(.leading, 58)
                    }
                }

                if viewModel.filteredItems.isEmpty {
                    Text("No encontramos productos con esa búsqueda.")
                        .font(.custom("AvenirNext-Regular", size: 15))
                        .foregroundStyle(BBVAColor.navy.opacity(0.7))
                        .padding(.vertical, 24)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: BBVAColor.navy.opacity(0.08), radius: 10, y: 4)
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(BBVAColor.navy.opacity(0.5))

            TextField("Buscar producto", text: $viewModel.searchText)
                .font(.custom("AvenirNext-Regular", size: 16))
                .foregroundStyle(BBVAColor.navy)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(BBVAColor.navy.opacity(0.35))
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background(BBVAColor.background, in: RoundedRectangle(cornerRadius: 12))
    }
}

/// Celda: imagen (SF Symbol), nombre y subtítulo.
private struct ItemRow: View {
    let item: ItemModel

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon)
                .font(.system(size: 16))
                .foregroundStyle(BBVAColor.coreBlue)
                .frame(width: 44, height: 44)
                .background(BBVAColor.lightBlue.opacity(0.2), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.custom("AvenirNext-DemiBold", size: 16))
                    .foregroundStyle(BBVAColor.blue)
                Text(item.subtitle)
                    .font(.custom("AvenirNext-Regular", size: 13))
                    .foregroundStyle(BBVAColor.navy.opacity(0.6))
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(BBVAColor.navy.opacity(0.3))
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    let session = SessionStore()
    session.login(User(name: "Cliente Demo", email: "demo@bbva.pe", password: "Bbva@2026"))
    return HomeView()
        .environmentObject(session)
}
