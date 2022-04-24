import SwiftUI
import MapKit
import CoreLocationUI


struct HomeView: View {
    @StateObject var viewModel = MapViewModel()
    @ObservedObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            Background {
                GeometryReader { geometry in
                    VStack(spacing: 0){
                        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                            .onAppear {
                                viewModel.checkIfLocationServicesIsEnabled()
                            }
                            .frame(height: geometry.size.height - 390)
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -38) {
                            Image(systemName: "plus")
                                .font(.system(size: 28))
                        }
                        // BUG: LocationButton crashes the app when sys langauge is changes to Finnish
                        /*LocationButton(.currentLocation) {
                            viewModel.checkIfLocationServicesIsEnabled()
                        }*/
                        .clipShape(Circle())
                        .font(.system(size: 25))
                        .position(x: geometry.size.width - 38, y: -109)
                        .zIndex(2)
                        .foregroundColor(.white)
                        .labelStyle(.iconOnly)
                        .tint(Color(hex: 0x221c48))
                    
                        Text(LocalizedStringKey("The Sound of \(viewModel.regionName)"))
                            .frame(width: geometry.size.width, alignment: .center)
                            .font(.title2)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.3))
                        
                        SongList()
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(authManager: AuthManager())
        }
    }
}
