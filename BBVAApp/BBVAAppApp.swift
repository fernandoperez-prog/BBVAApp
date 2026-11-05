import SwiftUI

@main
struct BBVAAppApp: App {
    @StateObject private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(session)
                .preferredColorScheme(.light)
        }
    }
}
