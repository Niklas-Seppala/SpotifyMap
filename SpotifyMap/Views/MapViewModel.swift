import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.224305, longitude: 24.757239)
    static let defaulSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

class MapViewModel: NSObject, ObservableObject,
                                CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaulSpan)
    @Published var regionName = ""
    var locationManager = CLLocationManager()
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location.coordinate, span: MapDetails.defaulSpan)
        }
        
        resolveRegionName(with: location) { [weak self] locationName in
            self?.regionName = locationName ?? "(unknown)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }
    
   private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location restircted")
        case .denied:
            print("location denied")
            let location = CLLocation(latitude: 60.224305, longitude: 24.757239)
            resolveRegionName(with: location) { [weak self] locationName in
                self?.regionName = locationName ?? "(unknown)"
            }
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaulSpan)
            print(region.center.longitude, region.center.latitude)
            
            let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            resolveRegionName(with: location) { [weak self] locationName in
                self?.regionName = locationName ?? "(unknown)"
            }

        @unknown default:
            break
        }
    }
    
    func resolveRegionName(with location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geoCoder = CLGeocoder()

        geoCoder.reverseGeocodeLocation(location) {placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {return}
            
            var regionName = ""
            
            if let location = placemark.subLocality {
                regionName = location
                
            }
            
            completion(regionName)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
