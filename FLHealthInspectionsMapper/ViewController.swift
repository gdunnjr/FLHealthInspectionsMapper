import UIKit
import GoogleMaps
import MapKit

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    var failedinspections: [FailedInspection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        
        //let failedInspection = FailedInspection(title: "Berry Fresh Cafe", inspectionDate: "3/1/2019", violation: "Bugs", address: "1234 St Lucie West Blvd, Port St. Lucie, FL 34986", countyName: "St. Lucie", countyValue: "st-lucie", coordinate: CLLocationCoordinate2D(latitude: 27.3110526, longitude: -80.4041787))
        
        //map.addAnnotation(failedInspection)
        
        loadInitialData()
        map.addAnnotations(failedinspections)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 2000, 2000)
        self.map.setRegion(viewRegion, animated: true)
     
        
        map.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        //map.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        map.addAnnotation(newPin)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! FailedInspection
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func loadInitialData() {
        // 1
        //guard let fileName = Bundle.main.path(forResource: "FailedFirstInspection.json", ofType: "json")
        //    else { return }
        let fileName = "/Users/geralddunn/FailedFirstInspection.json"
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        typealias JSONDictionary = [String:Any]
        
        do
        {
            if let parsedData = try JSONSerialization.jsonObject(with: optionalData!) as? JSONDictionary,
            let sports = parsedData["data"] as? [JSONDictionary] {
                for sport in sports {
                    print("county ", sport["CountyName"] as? String ?? "")
                    let name = sport["Name"] as? String ?? ""
                    let inspectionDate = sport["Date"] as? String ?? ""
                    let violation = sport["Violation"] as? String ?? ""
                    let address = sport["Address"] as? String ?? ""
                    let countyName = sport["CountyName"] as? String ?? ""
                    let countyValue = sport["CountyValue"] as? String ?? ""
                    let lat = Double(sport["Lat"] as? String ?? "0")
                    let lng = Double(sport["Lng"] as? String ?? "0")
                    
                    
                    let failedInspection = FailedInspection(title: name, inspectionDate: inspectionDate, violation: violation, address: address, countyName: countyName, countyValue: countyValue, coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: lng!))
                    
                failedinspections.append(failedInspection)
            }
            }
        }catch {}
        
                
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        
        
        //let validWorks = works.flatMap { FailedInspection(json: $0) }
        //failedinspections.append(contentsOf: validWorks)
 
 
    }
    
}

extension ViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? FailedInspection else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}




