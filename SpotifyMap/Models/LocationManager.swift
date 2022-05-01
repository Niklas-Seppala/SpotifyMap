import MapKit

// Enum for defining default location coordinates.
enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.224305, longitude: 24.757239)
    static let defaulSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    static let defaultLocation = CLLocation(latitude: 60.224305, longitude: 24.757239)
}

// Location model
struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D
}

// Class that handles all the location functionalities.
class LocationManager: NSObject, ObservableObject,
                                CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaulSpan)
    @Published var regionName = ""
    @Published var requestManager = RequestManager()
    @Published var locationManager = CLLocationManager()
    @Published var MapAlertIsPresented = false
    
    // Gets user's current location and updates it if found, assigns it to the region variable for re-centering the map.
    // Gets user's region name using the resolveRegionName function.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaulSpan)
        }
        
        // Assigns region name to regionName variable.
        // Gets the songs for the resolved region.
        resolveRegionName(with: location) { [weak self] locationName in
            self?.regionName = locationName ?? ""
            self?.requestManager.getAreaSongs(area: locationName ?? "Unknown")
        }
    }
    
    // Prints any locationManager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // Requests location if location services are enabled.
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }
    
    // Gets the region name of the center of the map using the resolveRegionName function
    // and the region songs using getAreSongs function.
    func getCenterLocation() {
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        resolveRegionName(with: location) { [weak self] locationName in
            self?.regionName = locationName ?? ""
            self?.requestManager.getAreaSongs(area: locationName ?? "Unknown")
        }
    }
    
    // Handle location permission cases.
    // If not determined asks user for permissions.
    // If denied show default location and resolve region name.
    // If authorized get user's coords, assign the region variable to them
    // and resolving user's region name.
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location restircted")
        case .denied:
            MapAlertIsPresented = true
            resolveRegionName(with: MapDetails.defaultLocation) { [weak self] locationName in
                self?.regionName = locationName ?? ""
            }
        case .authorizedAlways, .authorizedWhenInUse:
            guard let userCoords = locationManager.location?.coordinate else { return }
            region = MKCoordinateRegion(center: userCoords, span: MapDetails.defaulSpan)
            let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            
            resolveRegionName(with: location) { [weak self] locationName in
                self?.regionName = locationName ?? ""
                self?.requestManager.getAreaSongs(area: locationName ?? "Unknown")
            }
            
        @unknown default:
            break
        }
    }
    
    // Resolves region name by using reverse geocoding and returns the resolved region name.
    func resolveRegionName(with location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geoCoder = CLGeocoder()

        geoCoder.reverseGeocodeLocation(location) {placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            
            var regionName = ""
            
            if let location = placemark.subLocality {
                regionName = location
            }
            
            completion(regionName)
        }
    }
    
    // Gets coords and name of searched region by speech from the Location model.
    // Re-centers the map for that region and searches for the songs.
    func getRegionByVoice(_ speechToText: String) {
        resolveRegionCoordinates(with: speechToText) { [weak self] locations in
            if locations.indices.contains(0) {
                let locationCoords = locations[0].coordinates
                let locationName = locations[0].title
                
                self?.region = MKCoordinateRegion(center: locationCoords, span: MapDetails.defaulSpan)
                self?.regionName = locationName
                self?.requestManager.getAreaSongs(area: locationName)
            }

        }
    }
    
    // Using geocoding gets region coordinates and also resolve the region name.
    func resolveRegionCoordinates(with query: String, completion: @escaping (([Location]) -> Void)) {
        let geoCodeer = CLGeocoder()
        
        geoCodeer.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
               completion([])
                return
            }
            
            // Convert locations to the Location model.
            let models: [Location] = places.compactMap({ place in
                var name = ""
                if let locationName = place.subLocality {
                    name = locationName
                }
                
                let result  = Location(
                    title: name,
                    coordinates: place.location!.coordinate
                )
                
                return result
            })
            
            completion(models)
        }
    }
    
    // If location authorization status changes re-check location authorization.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
