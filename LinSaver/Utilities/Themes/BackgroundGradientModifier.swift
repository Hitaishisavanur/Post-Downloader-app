



import SwiftUI

struct BackgroundGradientModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: colorScheme == .dark ? Theme.darkBackgroundGradient : Theme.lightBackgroundGradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func applyBackgroundGradient() -> some View {
        self.modifier(BackgroundGradientModifier())
    }
}
