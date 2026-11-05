import SwiftUI

struct RootView: View {
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        if session.currentUser != nil {
            MainView()
        } else {
            NavigationStack {
                LoginView()
            }
        }
    }
}
