import UIKit
import MapKit

class ATOOffice:NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var identifier = "Pin"
    var Photo:UIImage! = nil
    init(coordinate:CLLocationCoordinate2D,title:String,subtitle:String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    
}
