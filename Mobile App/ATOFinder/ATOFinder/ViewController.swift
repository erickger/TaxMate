//
//  ViewController.swift
//  ATOFinder
//
//  Created by Zaidul Alam on 7/9/18.
//  Copyright © 2018 cmuGovhackTeam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    
    
     var points:[ATOOffice] = []
    
    @IBOutlet var mapView: MKMapView!
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? ATOOffice
            else{
                return nil
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        //annotationView.pinTintColor = UIColor.blue
        
        annotationView.image = UIImage(named: "pin")
        annotationView.canShowCallout = true
        
        
        let paragraph = UILabel()
        paragraph.numberOfLines = 0
        paragraph.font = UIFont.preferredFont(forTextStyle: .caption1)
        paragraph.text = annotation.subtitle
        paragraph.numberOfLines = 1
        paragraph.adjustsFontSizeToFitWidth = true
        annotationView.detailCalloutAccessoryView = paragraph
       if annotation.Photo == nil{ //default image
            annotation.Photo = UIImage(named: "pin")
        }
        annotationView.leftCalloutAccessoryView = UIImageView(image: annotation.Photo)
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        return annotationView
    }
    
    
    let manager=CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations[0]
        let span:MKCoordinateSpan=MKCoordinateSpanMake(0.003,0.003)
        let myLocation:CLLocationCoordinate2D=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion=MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation=true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate=self
        manager.desiredAccuracy=kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.loadCustomLocationsAll()
        print("call now")
        
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func search(_ sender: Any) {
        
        print("Called")
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        
        for locations in self.points
        {
            print(locations.title)
            //var artDrops = [salePoint]()
            
            
            self.mapView.addAnnotations([locations])
            
        }
        
    }
    
    
    
    func loadCustomLocationsAll(){
        
        print("from func")
        Database.database().reference(withPath: "ATOLocation")
        
        let artPin = Database.database().reference(withPath: "ATOLocation")
        
        
        artPin.observe(.value, with: { snapshot in
            
            
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot else { continue }
                if let dict = snapshot.value as? [String:AnyObject] {
                    
                    //let lat = (dict["lat"] as! NSString).doubleValue
                    //let lng = (dict["lang"] as! NSString).doubleValue
                    
                    let lat = dict["lat"] as! CLLocationDegrees
                    let lng = dict["lang"] as! CLLocationDegrees
                    print(lat,lng)
                    let title=dict["title"] as! String
                    let subtitle=dict["subtitle"] as! String
                    //let type=dict["type"] as! String
                    let ref = ATOOffice(coordinate: CLLocationCoordinate2DMake(lat,lng), title: title, subtitle: subtitle)
                    
                    self.points.append(ref)
                    print(self.points.count)
                }
                
            }
        })
        
       
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

