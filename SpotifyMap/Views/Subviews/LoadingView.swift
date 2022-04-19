import SwiftUI

struct LoadingView: View {
    let title: String
    
    var body: some View {
        Background {
            VStack {
                ProgressView()
                    .foregroundColor(.white)
                    .tint(.white)
                    .scaleEffect(3, anchor: .center)
                    .progressViewStyle(.circular)
                    .padding()
                Text(title)
                    .font(.title2)
            }
        }.foregroundColor(.white)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(title: "Logging in")
    }
}
