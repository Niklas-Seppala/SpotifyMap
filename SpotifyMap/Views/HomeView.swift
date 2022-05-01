import SwiftUI
import MapKit
import CoreLocationUI
import PopupView
import WebKit

struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var authManager: AuthManager
    @State var showingToast = false
    @State var toastMessage = ""
    @State var toastStatus = ToastStatus.Success
    @State var showBrowser = false
    
    func showToastMessage(toastText: String, status: ToastStatus) {
        toastMessage = toastText
        showingToast = true
        toastStatus = status
    }
    
    var body: some View {
        NavigationView {
            Background {
                GeometryReader { geometry in
                    VStack(spacing: 0){
                        ZStack(alignment: .top) {
                            // Map view that requests location on render.
                            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                                .frame(height: geometry.size.height - 390)
                                .popup(isPresented:$showingToast, type:.toast, position: .top, autohideIn: 10.0) {
                                    createTopToast(toastText: toastMessage, status: toastStatus)
                                }
                                .onAppear {
                                    locationManager.requestLocation()
                                }
                        }
                        .frame(height: geometry.size.height - 390)
                        
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -165, action: {
                            locationManager.getCenterLocation()
                        }) {
                                Image(systemName: "pin")
                                    .font(.system(size: 28))
                        }
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -104, action: {
                            locationManager.checkLocationAuthorization()
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 22))
                        }
                        .alert(isPresented: $locationManager.MapAlertIsPresented, content: {
                            Alert(title: Text(LocalizedStringKey("Location Alert")),
                                  message: Text(LocalizedStringKey("Please provide location permissions to this app in order to locate you.")),
                                  dismissButton: .default(Text("OK")))
                        })
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -43, action: {}) {
                            NavigationLink(destination: SearchView(songs: [])){
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                            }
                        }
                        // Gets region name fomr locationManager and renders it if found
                        locationManager.regionName == "" ?
                            Text(LocalizedStringKey("Can't detect a region here."))
                                .frame(width: geometry.size.width, alignment: .center)
                                .font(.title2)
                                .padding(.vertical, 12)
                                .background(Color.black.opacity(0.3))
                        :
                            Text(LocalizedStringKey("The Sound of \(locationManager.regionName)"))
                                .frame(width: geometry.size.width, alignment: .center)
                                .font(.title2)
                                .padding(.vertical, 12)
                                .background(Color.black.opacity(0.3))
                    
                        SongList(requestManager: locationManager.requestManager)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarBackButtonHidden(true)
            }
        }
        .task {
            if authManager.isSignedIn {
                showToastMessage(toastText: "Connected with Spotify", status: .Success)
            }
        }
    }
}
