//
//  MapViewController.swift
//  JarrodsCoffee
//
//  Created by Thursin Atkinson on 11/14/21.
// Coding lines are from Karl McPhee's maptest
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI


class MapViewController: UIViewController,
 MKMapViewDelegate,  CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    private var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!


    @IBAction func satelliteViewTypeButton(_ sender: Any) {
        self.mapView.mapType = MKMapType.hybridFlyover
    }
    
    @IBAction func standardViewTypeButton(_ sender: Any) {
        self.mapView.mapType = MKMapType.standard
    }
    
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
     
        print("GD button pressed")
    }
    
    
    
    let jarrodLoc = CLLocationCoordinate2D(latitude: 33.415490, longitude: -111.836050)
    let jarrodAnnotation = MKPointAnnotation()
    let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 33.415490, longitude: -111.836050), addressDictionary: nil)
    let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 33.415490, longitude: -111.836050), addressDictionary: nil))
    
    var mapTypes:[MKMapType] = [.hybrid, .satellite, .standard]

    override func viewDidLoad() {
        super.viewDidLoad()
        jarrodAnnotation.coordinate = jarrodLoc
        jarrodAnnotation.title = "Jarrod's Coffee, 154 W. Main St"
        mapView.addAnnotation(jarrodAnnotation)
        mapView.showsUserLocation = true
        showJarrodLocation()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        checkAuthorizationForLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3.0
            return renderer
        }
//    private func checkAuthorizationForLocation()
    func checkAuthorizationForLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .denied:
            showJarrodLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationForLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let location = locations.first else { return }
        //guard location.distance(from: lastLocation) > 50 else { return }
        let locationManager = manager
        locationManager.delegate = self
        var currentLoc: CLLocation!
        currentLoc = locationManager.location
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude)
        // Jarrod's Location
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        //let destinationPlacemark = MKPlacemark(coordinate: jarrodLoc, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        //let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        //let sourceAnnotation = MKPointAnnotation()
        //sourceAnnotation.title = "Current Location"
        //if let location = sourcePlacemark.location {
         //   sourceAnnotation.coordinate = location.coordinate
        //}
        
        //self.mapView.addAnnotations([sourceAnnotation,jarrodAnnotation])

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
                        
        directions.calculate(completionHandler:) { [self]
                            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }

            let route = response.routes[0]
            let padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: padding, animated: false)
        }
   }
    
    func showJarrodLocation() {
        mapView.addAnnotation(jarrodAnnotation)
        let region = MKCoordinateRegion(center: jarrodLoc, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: false)
        if CLLocationManager.locationServicesEnabled() {
           mapView.delegate = self
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }

}
