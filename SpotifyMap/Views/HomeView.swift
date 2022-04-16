import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }
}

struct HomeView: View {
    var body: some View {
        Background {
            GeometryReader { geometry in
                VStack(spacing: 0){
                    MapView()
                        .frame(height: geometry.size.height - 390)
                    CircleButton(xOffset: geometry.size.width - 38, yOffset: -38) {
                        Image(systemName: "plus")
                            .font(.system(size: 28))
                    }
                    CircleButton(xOffset: geometry.size.width - 38, yOffset: -109) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 22))
                    }
                    Text("The Sound of X")
                        .frame(width: geometry.size.width, alignment: .center)
                        .font(.title2)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.3))
                    
                    SongList()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
