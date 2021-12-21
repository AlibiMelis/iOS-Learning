//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Alibi on 3/25/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func loadView() {
        
        mapView = MKMapView()
        view = mapView
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = buttonConfigure()
        view.addSubview(button)
        print("MapViewController loaded its view.")
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Javed Multani"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)

        //centerMap(locValue)
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @IBAction func trackButtonTapped(_ sender: UIButton) {
        
        print("Button Pressed!")
//        mapView.delegate?.mapViewWillStartLocatingUser?(mapView)
//        mapView.setUserTrackingMode(.follow, animated: false)
//        mapView.showsUserLocation = true
//        let userLocation = mapView.userLocation
//        mapView.centerCoordinate = userLocation.coordinate
    }
    
    func buttonConfigure() -> UIButton {
        
        let buttonToTrack = UIButton(frame: CGRect(x: 150, y: 150, width: 200, height: 60))
        buttonToTrack.setTitle("Track me!", for: .normal)
//        let buttonWidth = buttonToTrack.widthAnchor.constraint(equalToConstant: 100)
//        let buttonHorizontal = buttonToTrack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
//        let buttonHeight = buttonToTrack.heightAnchor.constraint(equalToConstant: 50)
//        let buttonBottomConstraint = buttonToTrack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
//
//        buttonWidth.isActive = true
//        buttonHeight.isActive = true
//        buttonHorizontal.isActive = true
//        buttonBottomConstraint.isActive = true
        
        buttonToTrack.addTarget(self, action: #selector(trackButtonTapped(_ :)), for: .touchUpInside)
        
        return buttonToTrack
    }
}


