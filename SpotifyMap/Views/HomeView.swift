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
                                        viewModel.requestLocation()
                                        showToastMessage(toastText:"The toast works!")
                                    .frame(height: geometry.size.height - 390)
                                    .popup(isPresented:$showingToast, type:.toast, position: .top, autohideIn: 10.0) {
                                        createTopToast(toastText: toastMessage)
                                    }

                            }
                            .frame(height: geometry.size.height - 390)

                            CircleButton(xOffset: geometry.size.width - 38, yOffset: -38, action: {}) {
                            Image(systemName: "plus")
                                .font(.system(size: 28))
                            }
                            CircleButton(xOffset: geometry.size.width - 38, yOffset: -109, action: {
                                viewModel.checkLocationAuthorization()
                            }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 22))
                            }
                            .alert(isPresented: $viewModel.alertIsPresented, content: {
                                Alert(title: Text("Location Alert"),
                                      message: Text("Please give location permissions to this app in order to locate you."),
                                      dismissButton: .default(Text("Cancel")))
                            })
                                                
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
        .task {
            if authManager.isSignedIn {
                showToastMessage(toastText: "Connected with Spotify")
            }
        }
    }
}
