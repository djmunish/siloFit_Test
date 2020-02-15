//
//  HomeViewController.swift
//  siloFit
//
//  Created by Ankur Sehdev on 12/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit
import FirebaseDatabase
import SDWebImage

struct Spaces {
    var address: String
    var city: String
    var description: String
    var floor: String
    var image_urls: [String]
    var amenities: [String]
    var equipments: [String]
    var latitude: Double
    var longitude: Double
    var max_capacity : Int
    var name : String
    var open_days : String
    var open_hours : String
    var rate : Int
    var slug : String
    var space_id : String
    var square_footage : Int
    var status : String
    var timezone : String
}
struct FirebaseDatabaseKeys {
    struct Spaces {
        static let address = "address"
        static let city = "city"
        static let description = "description"
        static let floor = "floor"
        static let image_urls = "image_urls"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let max_capacity = "max_capacity"
        static let name = "name"
        static let open_days = "open_days"
        static let open_hours = "open_hours"
        static let rate = "rate"
        static let slug = "slug"
        static let space_id = "space_id"
        static let square_footage = "square_footage"
        static let status = "status"
        static let timezone = "timezone"
        static let equipments = "equipments"
        static let amenities = "amenities"
    }
}

class HomeViewController: UIViewController {
    @IBOutlet var tableView: UITableView! {
           didSet {
               tableView.delegate = self
               tableView.dataSource = self
           }
       }
    @IBOutlet weak var mapView: MKMapView!
    fileprivate var ref: DatabaseReference!
    fileprivate var spacesHandler: DatabaseHandle!
    fileprivate var spaces = [Spaces]()
    fileprivate let locationmanager:CLLocationManager = CLLocationManager()
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spaces"
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.distanceFilter = kCLDistanceFilterNone
        locationmanager.startUpdatingLocation()
//        locationmanager.delegate = self
        
        mapView.showsUserLocation = true
        
        fetchSpaces()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func fetchSpaces(){
        spacesHandler = ref.child("spaces").observe(.value) {
            (snapshot) in
            for child in snapshot.children {
                let s = child as? DataSnapshot
                let value = s?.value as? NSDictionary
                let add = value?[FirebaseDatabaseKeys.Spaces.address] as? String ?? ""
                let city = value?[FirebaseDatabaseKeys.Spaces.city] as? String ?? ""
                let desc = value?[FirebaseDatabaseKeys.Spaces.description] as? String ?? ""
                let floor = value?[FirebaseDatabaseKeys.Spaces.floor] as? String ?? ""
                let image_urls = value?[FirebaseDatabaseKeys.Spaces.image_urls] as? [String] ?? []
                let equip = value?[FirebaseDatabaseKeys.Spaces.equipments] as? [String] ?? []
                let amenities = value?[FirebaseDatabaseKeys.Spaces.amenities] as? [String] ?? []
                let lat = value?[FirebaseDatabaseKeys.Spaces.latitude] as? Double ?? 0.0
                let long = value?[FirebaseDatabaseKeys.Spaces.longitude] as? Double ?? 0.0
                let max = value?[FirebaseDatabaseKeys.Spaces.max_capacity] as? Int ?? 0
                let name = value?[FirebaseDatabaseKeys.Spaces.name] as? String ?? ""
                let openDay = value?[FirebaseDatabaseKeys.Spaces.open_days] as? String ?? ""
                let openHours = value?[FirebaseDatabaseKeys.Spaces.open_hours] as? String ?? ""
                let rate = value?[FirebaseDatabaseKeys.Spaces.rate] as? Int ?? 0
                let slug = value?[FirebaseDatabaseKeys.Spaces.slug] as? String ?? ""
                let spcaeId = value?[FirebaseDatabaseKeys.Spaces.space_id] as? String ?? ""
                let sqFt = value?[FirebaseDatabaseKeys.Spaces.square_footage] as? Int ?? 0
                let timeZone = value?[FirebaseDatabaseKeys.Spaces.timezone] as? String ?? ""
                let status = value?[FirebaseDatabaseKeys.Spaces.status] as? String ?? ""
                
                let c = Spaces(address: add, city: city, description: desc, floor: floor, image_urls: image_urls, amenities: amenities, equipments: equip, latitude: lat, longitude: long, max_capacity: max, name: name, open_days: openDay, open_hours: openHours, rate: rate, slug: slug, space_id: spcaeId, square_footage: sqFt, status: status, timezone: timeZone)
                self.spaces.append(c)
            }
            print(self.spaces)
            self.plotSpaces()
            self.tableView.reloadData()
        }
        
    }
    
    func plotSpaces(){
        for s in spaces{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: s.latitude, longitude: s.longitude)
            annotation.title = s.name
            annotation.subtitle = s.address
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func listAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tableView.isHidden = !sender.isSelected
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:{  action in
        self.navigationController?.popToRootViewController(animated: false)
        })
        )
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
        
    }
    //MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue") {
            let destinationViewController = (segue.destination as! DetailsViewController)
            destinationViewController.spaceSelected = sender as? Spaces
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//extension HomeViewController: CLLocationManagerDelegate{
//    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        locationmanager.stopUpdatingLocation()
//        if ((error) != nil) {
//            if (seenError == false) {
//                seenError = true
//               print(error)
//            }
//        }
//    }
//
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        if (self.locationFixAchieved == false) {
//            locationFixAchieved = true
//            var locationArray = locations as NSArray
//            var locationObj = locationArray.lastObject as! CLLocation
//            var coord = locationObj.coordinate
//
//            print(coord.latitude)
//            print(coord.longitude)
//            mapView.showsUserLocation = true
//        }
//    }
//}
//MARK: - Tableview Datasource and Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpacesCell") as! SpacesCell
        let space = self.spaces[indexPath.row]
        cell.rateLbl.text = "FROM $ \(String(describing: space.rate)) /HR"
        cell.areaLbl.text = "\(String(describing: space.square_footage)) SQ. FT"
        cell.addLbl.text = space.name
        cell.capacityLbl.text = "UP TO \(String(describing: space.max_capacity)) PEOPLE"
        cell.photoView.imageFromURL(urlString: space.image_urls[0])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let space = self.spaces[indexPath.row]
        self.performSegue(withIdentifier: "detailSegue", sender: space)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

