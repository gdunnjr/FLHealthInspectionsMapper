import MapKit
import Contacts

class FailedInspection: NSObject, MKAnnotation {
    let title: String?
    let inspectionDate: String
    let violation: String
    let address: String
    let countyName: String
    let countyValue: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, inspectionDate: String,violation: String, address: String, countyName: String,
         countyValue: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.inspectionDate = inspectionDate
        self.violation = violation
        self.address = address
        self.countyName = countyName
        self.countyValue = countyValue
        self.coordinate = coordinate
        
        super.init()
    }
    
    init?(json: [String]) {
        // 1
        
        
        self.title = json[0]
        self.inspectionDate = json[1]
        self.violation = json[2]
        self.address = json[3]
        self.countyName = json[4]
        self.countyValue = json[5]
        
        // 2
        if let latitude = Double(json[6] as! String),
            let longitude = Double(json[7] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }

    /*
    init?(json: [Any]) {
        // 1
    
    
        self.title = json[0] as? String ?? "No Name"
        self.inspectionDate = json[1] as! String
        self.violation = json[2] as! String
        self.address = json[3] as! String
        self.countyName = json[4] as! String
        self.countyValue = json[5] as! String
        
        // 2
        if let latitude = Double(json[6] as! String),
            let longitude = Double(json[7] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
*/
    
    var subtitle: String? {
        return violation
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
