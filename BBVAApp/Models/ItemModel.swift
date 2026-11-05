import Foundation

/// Producto BBVA. Struct Identifiable y Hashable (necesario para navigationDestination).
struct ItemModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subtitle: String
    let icon: String          // SF Symbol
    let category: String
    let rate: String
    let requirements: String
    let benefit: String
    let description: String
}
