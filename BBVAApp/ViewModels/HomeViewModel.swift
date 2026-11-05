import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var items: [ItemModel] = [
        ItemModel(
            name: "Cuenta de Ahorros",
            subtitle: "Ahorra sin comisión de mantenimiento",
            icon: "banknote.fill",
            category: "Cuentas",
            rate: "Hasta 1.5% TREA",
            requirements: "DNI vigente y monto inicial de S/ 50",
            benefit: "Sin comisión de mantenimiento",
            description: "Una cuenta simple para guardar tu dinero y manejarlo desde tu celular, las 24 horas."
        ),
        ItemModel(
            name: "Cuenta Sueldo",
            subtitle: "Recibe tu pago de forma segura",
            icon: "creditcard.and.123",
            category: "Cuentas",
            rate: "Sin costo de mantenimiento",
            requirements: "Convenio de tu empleador con BBVA",
            benefit: "Retiros gratis en cajeros BBVA",
            description: "Recibe tu sueldo directamente en tu cuenta y accede a beneficios exclusivos."
        ),
        ItemModel(
            name: "Tarjeta de Crédito",
            subtitle: "Compra hoy y paga después",
            icon: "creditcard.fill",
            category: "Tarjetas",
            rate: "TEA desde 39%",
            requirements: "Ingresos mínimos de S/ 1,500",
            benefit: "Puntos por cada compra",
            description: "Paga tus compras con comodidad y acumula puntos que puedes canjear por premios."
        ),
        ItemModel(
            name: "Tarjeta de Débito",
            subtitle: "Paga con tu propio dinero",
            icon: "creditcard",
            category: "Tarjetas",
            rate: "Sin costo de emisión",
            requirements: "Tener una cuenta BBVA",
            benefit: "Pagos sin contacto",
            description: "Usa el saldo de tu cuenta para comprar en tiendas y por internet de forma segura."
        ),
        ItemModel(
            name: "Préstamo Personal",
            subtitle: "Dinero rápido para tus proyectos",
            icon: "dollarsign.circle.fill",
            category: "Préstamos",
            rate: "TEA desde 18%",
            requirements: "Ingresos comprobables y DNI",
            benefit: "Desembolso en 24 horas",
            description: "Financia tus planes con cuotas fijas y plazos de hasta 60 meses."
        ),
        ItemModel(
            name: "Crédito Hipotecario",
            subtitle: "Compra la casa de tus sueños",
            icon: "house.fill",
            category: "Préstamos",
            rate: "TEA desde 8.5%",
            requirements: "Cuota inicial del 10% e ingresos estables",
            benefit: "Plazos de hasta 20 años",
            description: "Financia tu vivienda con acompañamiento de un asesor en todo el proceso."
        ),
        ItemModel(
            name: "Seguro de Vida",
            subtitle: "Protege a quienes más quieres",
            icon: "heart.fill",
            category: "Seguros",
            rate: "Desde S/ 15 al mes",
            requirements: "Ser mayor de 18 años",
            benefit: "Cobertura por fallecimiento",
            description: "Un respaldo económico para tu familia ante cualquier imprevisto."
        ),
        ItemModel(
            name: "Seguro Vehicular",
            subtitle: "Maneja con tranquilidad",
            icon: "car.fill",
            category: "Seguros",
            rate: "Desde S/ 60 al mes",
            requirements: "Vehículo con antigüedad menor a 15 años",
            benefit: "Asistencia en carretera 24/7",
            description: "Cubre daños, robo y responsabilidad civil para tu auto."
        ),
        ItemModel(
            name: "Depósito a Plazo",
            subtitle: "Haz crecer tu dinero",
            icon: "chart.line.uptrend.xyaxis",
            category: "Inversiones",
            rate: "Hasta 5% TREA",
            requirements: "Monto mínimo de S/ 1,000",
            benefit: "Rentabilidad garantizada",
            description: "Deja tu dinero a un plazo fijo y recibe intereses al finalizar."
        ),
        ItemModel(
            name: "Fondos Mutuos",
            subtitle: "Invierte con apoyo de expertos",
            icon: "chart.pie.fill",
            category: "Inversiones",
            rate: "Rentabilidad variable",
            requirements: "Monto mínimo de S/ 500",
            benefit: "Portafolios según tu perfil",
            description: "Invierte en distintos instrumentos manejados por especialistas."
        )
    ]

    @Published var searchText = ""

    /// Lista filtrada. Se recalcula solo cuando cambian items o searchText.
    @Published private(set) var filteredItems: [ItemModel] = []

    init() {
        filteredItems = items

        Publishers.CombineLatest($items, $searchText)
            .map { items, text in
                let query = text.trimmingCharacters(in: .whitespaces)
                guard !query.isEmpty else { return items }
                return items.filter {
                    $0.name.localizedCaseInsensitiveContains(query)
                    || $0.subtitle.localizedCaseInsensitiveContains(query)
                    || $0.category.localizedCaseInsensitiveContains(query)
                }
            }
            .assign(to: &$filteredItems)
    }
}
