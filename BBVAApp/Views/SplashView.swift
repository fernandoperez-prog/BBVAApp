import SwiftUI

struct SplashView: View {
    // @State: estado simple, local y propio de esta vista (valores Bool).
    @State private var animate = false
    @State private var showLogin = false

    var body: some View {
        if showLogin {
            RootView()
                .transition(.opacity)
        } else {
            ZStack {
                BBVAColor.blue
                    .ignoresSafeArea()

                Image("bbva_logo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280)
                    .foregroundStyle(.white)
                    .scaleEffect(animate ? 1 : 0.6)
                    .opacity(animate ? 1 : 0)
            }
            .transition(.opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    animate = true
                }
            }
            .task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation(.easeInOut(duration: 0.4)) {
                    showLogin = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(SessionStore())
}
