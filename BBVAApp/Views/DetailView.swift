import SwiftUI

struct DetailView: View {
    let item: ItemModel

    @State private var showConfirmation = false

    private let actions: [(title: String, icon: String, color: Color)] = [
        ("Contratar", "checkmark", Color(hex: "#3DCB6B")),
        ("Simular", "slider.horizontal.3", Color(hex: "#4FA8D6")),
        ("Asesor", "person.fill", Color(hex: "#7C5CD6")),
        ("Más info", "ellipsis", BBVAColor.blue)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Tarjeta azul BBVA superior
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(BBVAColor.blue)

                    VStack(alignment: .leading) {
                        HStack {
                            Image("bbva_logo")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70)
                                .foregroundStyle(.white)

                            Spacer()

                            Text(item.category.uppercased())
                                .font(.custom("AvenirNext-DemiBold", size: 11))
                                .foregroundStyle(.white.opacity(0.8))
                        }

                        Spacer()

                        Image(systemName: item.icon)
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)

                        Spacer()

                        Text(item.rate)
                            .font(.custom("AvenirNext-Bold", size: 20))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(20)
                }
                .frame(height: 230)

                // Acciones rápidas (círculos de colores)
                HStack(alignment: .top, spacing: 0) {
                    ForEach(actions, id: \.title) { action in
                        Button {
                            if action.title == "Contratar" {
                                showConfirmation = true
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: action.icon)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 54, height: 54)
                                    .background(action.color, in: Circle())

                                Text(action.title)
                                    .font(.custom("AvenirNext-Medium", size: 11))
                                    .foregroundStyle(BBVAColor.navy.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.plain)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(item.category.uppercased())
                        .font(.custom("AvenirNext-DemiBold", size: 11))
                        .foregroundStyle(BBVAColor.navy)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(BBVAColor.aqua.opacity(0.25), in: Capsule())

                    Text(item.name)
                        .font(.custom("AvenirNext-Bold", size: 28))
                        .foregroundStyle(BBVAColor.blue)

                    Text(item.description)
                        .font(.custom("AvenirNext-Regular", size: 16))
                        .foregroundStyle(BBVAColor.navy.opacity(0.75))
                }

                // Atributos del modelo
                VStack(spacing: 0) {
                    InfoRow(icon: "percent", title: "Tasa o costo", value: item.rate)
                    Divider().padding(.leading, 66)
                    InfoRow(icon: "checkmark.seal", title: "Beneficio", value: item.benefit)
                    Divider().padding(.leading, 66)
                    InfoRow(icon: "doc.text", title: "Requisitos", value: item.requirements)
                }
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: BBVAColor.navy.opacity(0.06), radius: 8, y: 3)

                Button("Quiero este producto") {
                    showConfirmation = true
                }
                .buttonStyle(BBVAButtonStyle())
                .padding(.top, 4)
            }
            .padding(20)
        }
        .background(BBVAColor.background.ignoresSafeArea())
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(BBVAColor.blue, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Solicitud enviada", isPresented: $showConfirmation) {
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text("Un asesor BBVA se pondrá en contacto contigo para \(item.name).")
        }
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(BBVAColor.coreBlue)
                .frame(width: 36, height: 36)
                .background(BBVAColor.lightBlue.opacity(0.2), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("AvenirNext-Regular", size: 13))
                    .foregroundStyle(BBVAColor.navy.opacity(0.6))
                Text(value)
                    .font(.custom("AvenirNext-DemiBold", size: 16))
                    .foregroundStyle(BBVAColor.blue)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
    }
}

#Preview {
    NavigationStack {
        DetailView(item: HomeViewModel().items[0])
    }
}
