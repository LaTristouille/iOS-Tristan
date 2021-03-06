//
//  MapViewController.swift
//  Demo
//
//  Created by Julie Saby on 09/03/2020.
//  Copyright © 2020 Julie Saby. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    static let sharedInstance = MapViewController()
        let annotation = CustomAnnotation()
        
        var monus = [Monu]()
        var annotations = [CustomAnnotation]()
        
        var selectedMonu: Monu?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            mapView.delegate = self
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
            // Nous centrons la carte sur la latitude et la longitude passée en paramètre
           /* let center = CLLocationCoordinate2D(latitude: 45.19193413, longitude: 5.72666532)
            centerMap(onLocation: center)*/
            
            self.monus = MonuContext.shared.monus
            
            monus.forEach { monu in
                let annotation = CustomAnnotation()
                annotation.id = monu.id
                annotation.website = monu.website
                annotation.coordinate = CLLocationCoordinate2D(latitude: monu.latitude, longitude: monu.longitude)
                annotation.title = monu.name
                annotation.subtitle = monu.adress
                annotations.append(annotation)
                
                mapView.addAnnotation(annotation)
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            //Si on a un monument quand la vue apparait, alors on centre sur les coordonnées de celui-ci par exemple
            if let monumentToDisplay = self.selectedMonu {
                let center = CLLocationCoordinate2D(latitude: monumentToDisplay.latitude, longitude: monumentToDisplay.longitude)
                centerMap(onLocation: center, 2000)
                
                let annotationToOpen = self.annotations.first(where: {$0.id == monumentToDisplay.id})
                if annotationToOpen != nil {
                    DispatchQueue.main.async {
                        //Pour la sélectionner
                        self.mapView.selectAnnotation(annotationToOpen!, animated: true)
                    }
                }
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            //Quand on quitte la carte, on supprimes le monu pour ne pas revenir dessus à la sélection du tab Map
            self.selectedMonu = nil
        }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          
          let location = locations[0]
          
          let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
          let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
          
          let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
          
          mapView.setRegion(region, animated: true)
          self.mapView.showsUserLocation = true
          
      }
        
        func centerMap(onLocation location: CLLocationCoordinate2D, _ meters: CLLocationDistance? = 20000) {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: meters!, longitudinalMeters: meters!)
            mapView.setRegion(region,animated: true)
        }
        
        //MARK: -- Annotations --
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is CustomAnnotation {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
                
                let rightButton = UIButton(type: .infoLight)
                rightButton.tag = annotation.hash
                
                pinView.animatesDrop = true
                pinView.canShowCallout = true
                pinView.rightCalloutAccessoryView = rightButton
                pinView.isUserInteractionEnabled = true
                
                return pinView
            }
            return nil
        }
        
        func mapView(_ mapView:MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                print(view.annotation?.title as Any)
                
                if let annotation = view.annotation as? CustomAnnotation {
                    let detailsViewController = storyboard?.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
                    
                    if let monu = monus.first(where: { $0.id == annotation.id }) {
                        detailsViewController.monu = monu
                    }
                    
                    UIApplication.shared.open(URL(string: annotation.website!)! as URL, options: [:], completionHandler: nil)
                }
            }
            
        }
}
