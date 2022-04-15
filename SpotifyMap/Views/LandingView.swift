import SwiftUI

struct LandingView: View {
    
    @State private var isViewingSpotifyAuth = false
    
    var body: some View {
        VStack {
            Text("LOGO")
                .font(.system(size: 60))
            
            Spacer()
            
            ShadowRect(height: 260) {
                Text("Connect your")
                    .font(.system(size: 30))
                
                Image("SpotifyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 70)
            }.onTapGesture {
                isViewingSpotifyAuth = true
            }
            .sheet(isPresented: $isViewingSpotifyAuth) {
                Button(action: { isViewingSpotifyAuth = false }, label: {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 30))
                })
                .foregroundColor(.black)
                .padding(.top)
                
                SpotifyAuthView()
            }
            
            //.sheet(isPresented: $isViewingSpotifyAuth) {
            //    SpotifyAuthView().padding(.top, 50)
            //}
            
            Spacer()
            Spacer()
            
            NavigationLink(destination: HomeView()) {
                ShadowRect(height: 250) {
                
                Text("Continue as a guest")
                    .font(.title)
                Text("with limited features")
                    .font(.title2)
                
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                }
            }

            Spacer()
        }
        .tint(.green)
        .preferredColorScheme(.dark)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LandingView()
        }
    }
}
