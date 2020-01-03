//
//  MapViewController.swift
//  Warranty Wallet
//
//  Created by Zaeni Hoque on 12/17/19.
//  Copyright © 2019 Zaeni Hoque. All rights reserved.
//

import UIKit
import MapKit

class customPin: NSObject, MKAnnotation
{
    var coordinate : CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D )
    {
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
    }
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set location
        var location = CLLocationCoordinate2DMake(25.2048, 55.2708)
        
        // set map span
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        // set region
        let region = MKCoordinateRegion(center: location, span: mapSpan)
        
        // set location pin
        let pin = customPin(pinTitle:"United Arab Emirates", pinSubtitle: "Middle East", location: location)
        self.map.addAnnotation(pin)
        self.map.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }
    
    // function to view map
    func mapView(_ mapView:MKMapView, viewFor annotation: MKAnnotation)->  MKAnnotationView?
        {
            if annotation is MKUserLocation
            {
                return nil
            }
        
    
            let annotationView = MKAnnotationView(annotation : annotation , reuseIdentifier: "customannotation")
            annotationView.image = UIImage(named: "pin")
            annotationView.canShowCallout = true
            return annotationView
        }
        func mapView(_ mapView:MKMapView, didSelect view: MKAnnotationView)
        {
            print("ANNOTATION TITLE ==\(String(describing: view.annotation?.title!))")
            
        }
    

}
