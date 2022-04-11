import SwiftUI

struct ContentView: View {
    var body: some View {
        Background {
            LandingView()
                .foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
