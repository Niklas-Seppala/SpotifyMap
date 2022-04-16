//
//  MapViewModel.swift
//  SpotifyMap
//
//  Created by iosdev on 16.4.2022.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.224305, longitude: 24.757239)
    static let defaulSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
}

class MapViewModel: NSObject, ObservableObject,
                                CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaulSpan)
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
    

            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }
    }
    
   private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location restircted")
        case .denied:
            print("location denied")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaulSpan)
            print(region.center.longitude, region.center.latitude)
            
            let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            resolveRegionName(with: location) { [weak self] locationName in
                // self?.title = locationName
                print("Current location: ", locationName ?? "none")
            }

        @unknown default:
            break
        }
    }
    
    func resolveRegionName(with location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geoCoder = CLGeocoder()

        geoCoder.reverseGeocodeLocation(location) {placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {return}
            print(placemarks ?? "no pm")
            
            var stName = ""
            
            if let street = placemark.thoroughfare {
                print(street)
                stName = street
            }
            
            completion(stName)
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
