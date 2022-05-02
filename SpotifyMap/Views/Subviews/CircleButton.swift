import SwiftUI

// Custom floating button component with absolute positioning
struct CircleButton<T: View> : View {
    let xOffset: CGFloat
    let yOffset: CGFloat
    var content: () -> T
    var action: () -> Void
    
    
    init(xOffset: CGFloat, yOffset: CGFloat, action: @escaping () -> Void, @ViewBuilder content: @escaping () -> T) {
        self.content = content
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
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
