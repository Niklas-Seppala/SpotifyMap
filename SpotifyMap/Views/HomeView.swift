import SwiftUI
import MapKit
import CoreLocationUI
import PopupView

struct HomeView: View {
    @StateObject var viewModel = MapViewModel()
    @ObservedObject var authManager: AuthManager
    @State var showingToast = false
    @State var toastMessage = ""
    
    func showToastMessage(toastText: String) {
        toastMessage = toastText
        showingToast = true
    }
    
    var body: some View {

            NavigationView {
                Background {
                    GeometryReader { geometry in
                        VStack(spacing: 0){
                            ZStack(alignment: .top) {
                                Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                                    .onAppear {
                                        viewModel.checkIfLocationServicesIsEnabled()
                                        showToastMessage(toastText:"The toast works!")
                                    }
                                    .frame(height: geometry.size.height - 390)
                                    .popup(isPresented:$showingToast, type:.toast, position: .top, autohideIn: 10.0) {
                                        createTopToast(toastText: toastMessage)
                                    }

                            }
                            .frame(height: geometry.size.height - 390)

                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -38) {
                            Image(systemName: "plus")
                                .font(.system(size: 28))
                        }

                        // BUG: LocationButton crashes the app when sys langauge is changes to Finnish
                        /*LocationButton(.currentLocation) {
                            viewModel.checkIfLocationServicesIsEnabled()
                        }
                        .clipShape(Circle())
                        .font(.system(size: 25))
                        .position(x: geometry.size.width - 38, y: -109)
                        .zIndex(2)
                        .foregroundColor(.white)
                        .labelStyle(.iconOnly)
                        .tint(Color(hex: 0x221c48))*/
                        
                        if (!viewModel.requestManager.isLoading) {
                            Text(LocalizedStringKey("The Sound of \(viewModel.regionName)"))
                                .frame(width: geometry.size.width, alignment: .center)
                                .font(.title2)
                                .padding(.vertical, 12)
                                .background(Color.black.opacity(0.3))
                            SongList(requestManager: viewModel.requestManager)
                        } else {
                            LoadingView(title: "")
                                .frame(height: geometry.size.height - 390)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}
