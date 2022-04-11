import SwiftUI

struct ShadowRect<T: View> : View {
    let height: CGFloat
    var content: () -> T
        
    init(height: CGFloat, @ViewBuilder content: @escaping () -> T) {
        self.content = content
        self.height = height
    }
    
    var body: some View {
        VStack {
            content()
        }.background {
            // Yes its retarded :)
            // Will look into it more later.
            Rectangle()
                .size(width: 600, height: height)
                .offset(x: -200, y: -height / 4)
                .rotation(Angle(degrees: -5.0))
                .fill(Color(hex: 0x000000, alpha: 0.4))
        }
    }
}

struct ShadowRect_Previews: PreviewProvider {
    static var previews: some View {
        ShadowRect(height: 300) {
            Text("Connect your")
                .font(.system(size: 30))
            
            Image("SpotifyLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 80)
        }
        .foregroundColor(.white)
    }
}
