import SwiftUI

struct Background<T: View> : View {
    var content: () -> T
    
    init(@ViewBuilder content: @escaping () -> T) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: BACKGROUND_GRADIENT, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            content()
        }
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background() {}
    }
}
