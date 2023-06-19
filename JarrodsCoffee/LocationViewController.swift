//
//  LocationViewController.swift
//  JarrodsCoffee
//
//  Created by Thursin Atkinson on 11/30/21.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    var locationManager = CLLocationManager()
    let jaredLoc = CLLocationCoordinate2D(latitude: 33.415490, longitude: -111.836050)
    let annotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        annotation.coordinate = jaredLoc
        annotation.title = "Jared's Coffee"
        mapView2.addAnnotation(annotation)
        let center = jaredLoc
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView2.setRegion(region, animated: true)
        if CLLocationManager.locationServicesEnabled() {
            mapView2.delegate = self
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
       //    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
       //   consumes less battery
            checkAuthorizationForLocation()
            locationManager.startUpdatingLocation()
    }
    }

    

 /*
    Add this if you want to lock the map around jared's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations.last! as CLLocation
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let center = CLLocationCoordinate2D(latitude: 33.415490, longitude: -111.836050)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView2.setRegion(region, animated: true)
    }
 */
    
    func checkAuthorizationForLocation() {
    
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse, .authorizedAlways:
        mapView2.showsUserLocation = true
    case .denied: break
    case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        mapView2.showsUserLocation = true
    case .restricted: break
    @unknown default:
        break
    }
        


}
  
}
