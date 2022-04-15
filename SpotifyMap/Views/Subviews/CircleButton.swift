import SwiftUI

struct CircleButton<T: View> : View {
    let xOffset: CGFloat
    let yOffset: CGFloat
    var content: () -> T
    
    init(xOffset: CGFloat, yOffset: CGFloat, @ViewBuilder content: @escaping () -> T) {
        self.content = content
        self.xOffset = xOffset
        self.yOffset = yOffset
    }
    
    var body: some View {
        Button(action: {}) {
            content()
                .frame(width: 56, height: 56)
        }
        .background(Color(hex: 0x221c48))
        .foregroundColor(Color.white)
        .clipShape(Circle())
        .position(x: xOffset, y: yOffset)
        .zIndex(2)
    }
}
