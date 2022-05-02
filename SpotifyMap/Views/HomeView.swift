import SwiftUI
import MapKit
import CoreLocationUI
import PopupView
import WebKit
import Combine

struct HomeView: View {
    @StateObject var viewModel = MapViewModel()
    @EnvironmentObject var authManager: AuthManager
    @State var showingToast = false
    @State var toastMessage = ""
    @State var toastStatus = ToastStatus.Success
    @State var showBrowser = false
    @State var responseCancellable: AnyCancellable?
    @State var errorCancellable: AnyCancellable?
    
    func showToastMessage(toastText: String, status: ToastStatus) {
        
        toastMessage = toastText
        showingToast = true
        toastStatus = status
        print("showToastMessage is called msg: \(toastText) show: \(showingToast) status: \(toastStatus)")
    }
    
    var body: some View {
        NavigationView {
            Background {
                GeometryReader { geometry in
                    VStack(spacing: 0){
                        ZStack(alignment: .top) {
                            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                                .frame(height: geometry.size.height - 390)
                                .popup(isPresented:$showingToast, type:.toast, position: .top, autohideIn: 10.0) {
                                    createTopToast(toastText: toastMessage, status: toastStatus)
                                }
                                .onAppear {
                                    viewModel.requestLocation()
                                }
                        }
                        .frame(height: geometry.size.height - 390)
                        
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -165, action: {
                            viewModel.getCenterLocation()
                        }) {
                                Image(systemName: "pin")
                                    .font(.system(size: 28))
                        }
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -104, action: {
                            viewModel.checkLocationAuthorization()
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 22))
                        }
                        .alert(isPresented: $viewModel.alertIsPresented, content: {
                            Alert(title: Text(LocalizedStringKey("Location Alert")),
                                  message: Text(LocalizedStringKey("Please give location permissions to this app in order to locate you.")),
                                  dismissButton: .default(Text("OK")))
                        })
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -43, action: {}) {
                            NavigationLink(destination: SearchView(songs: [])){
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                            }
                        }
 
                        viewModel.regionName == "" ?
                            Text(LocalizedStringKey("Can't detect a region here."))
                                .frame(width: geometry.size.width, alignment: .center)
                                .font(.title2)
                                .padding(.vertical, 12)
                                .background(Color.black.opacity(0.3))
                        :
                            Text(LocalizedStringKey("The Sound of \(viewModel.regionName)"))
                                .frame(width: geometry.size.width, alignment: .center)
                                .font(.title2)
                                .padding(.vertical, 12)
                                .background(Color.black.opacity(0.3))
                        
                        SongList(requestManager: viewModel.requestManager).onAppear {
                            print("SongList onAppear!")
                            
                            //showToastMessage(toastText: "onAppear", status: .Error)
                            responseCancellable = viewModel.$response.sink(receiveValue: {
                              resp in
                                if(resp?.statusCode != nil && resp?.statusCode != 200) {
                                    print("homeview resp sink code \(resp)")
                                    // TODO: Localize
                                    showToastMessage(toastText: "Server error!", status: .Error)
                                }
                            })
                            
                            errorCancellable = viewModel.$err.sink(receiveValue: {
                              err in
                                print("receive error sink \(err)")
                                if(err != nil) {
                                    print("homeview error sink code \(err) not nil \(err != nil)")
                                    // TODO: Localize
                                    showToastMessage(toastText: "Network error!", status: .Error)
                                }
                            })

                        }

                        
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
