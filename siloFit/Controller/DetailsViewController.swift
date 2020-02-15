//
//  DetailsViewController.swift
//  siloFit
//
//  Created by Ankur Sehdev on 14/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit
import MapKit
import AXPhotoViewer

class DetailsViewController: UIViewController {
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var pageCOntroll: UIPageControl!
    var spaceSelected:Spaces!
    var photoAXArray = [AXPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        conversion()
        pageCOntroll.numberOfPages = spaceSelected.image_urls.count
        // Do any additional setup after loading the view.
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageCOntroll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func conversion(){
        for photo in spaceSelected.image_urls{
            let axPhoto = AXPhoto(attributedTitle: nil, attributedDescription: nil, attributedCredit: nil, imageData: nil, image: nil, url: URL(string: photo))
            photoAXArray.append(axPhoto)
        }
        
    }
    
    func plotSpaces(s:Spaces, map:MKMapView){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: s.latitude, longitude: s.longitude)
        annotation.title = s.name
        annotation.subtitle = s.address
        map.addAnnotation(annotation)
        map.setCenter(annotation.coordinate, animated: false)
    }
}
//MARK: - Tableview Datasource and Delegate
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
            let space = spaceSelected
            cell.images.tag = 3000
            cell.rateLbl.text = "FROM $ \(String(describing: space!.rate)) /HR"
            cell.areaLbl.text = "\(String(describing: space!.square_footage)) SQ. FT"
            cell.addLbl.text = space?.name
            cell.capacityLbl.text = "UP TO \(String(describing: space!.max_capacity)) PEOPLE"
            cell.descLbl.text = space?.description
            return cell
        }
        else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapCell
            cell.addMap.text = spaceSelected.address
            self.plotSpaces(s: spaceSelected, map: cell.map)
            cell.dayOpenLbl.text = spaceSelected.open_days
            cell.timeOpenLbl.text = spaceSelected.open_hours
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreDetailCell") as! MoreDetailCell
            cell.titleLbl.text = indexPath.row == 1 ? "Equipment" : "Amenities"
            cell.dataList.tags = indexPath.row == 1 ? 4000 : 5000
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is DetailCell
        {   
        let tableViewCell1 = cell as? DetailCell
            tableViewCell1?.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    else{
        let tableViewCell2 = cell as? MoreDetailCell
            tableViewCell2?.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }


    }
    
}

extension DetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if spaceSelected.image_urls.count > 0 {
//            return spaceSelected.image_urls.count
//        }
//        else {
//            return collectionView.tag == 4000 ? spaceSelected.equipments.count : spaceSelected.amenities.count
//        }
        
        if collectionView is PhotosCollectionView {
            return spaceSelected.image_urls.count
        } else {
            return spaceSelected.equipments.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is PhotosCollectionView {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            return CGSize(width: width, height: 240)
        }
        else
        {
            return CGSize(width: 80, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is PhotosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as? PhotosCell
            cell?.photo.imageFromURL(urlString: spaceSelected.image_urls[indexPath.item])
            return cell!
        }
        else{
            let clcView = collectionView as? DataCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath) as? OptionsCell
            cell?.optionNameLbl.text = clcView?.tags == 4000 ?  spaceSelected.equipments[indexPath.item] : spaceSelected.amenities[indexPath.item]
            print(spaceSelected.equipments[indexPath.item])
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                    
        let dataSource = AXPhotosDataSource(photos: self.photoAXArray, initialPhotoIndex: indexPath.row)
            let photosViewController = AXPhotosViewController(dataSource: dataSource, pagingConfig: nil, transitionInfo: nil)
            photosViewController.modalPresentationStyle = .fullScreen
            let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            let bottomView = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44)))
            bottomView.items = [
                flex,
                flex,
                flex,
            ]
            bottomView.backgroundColor = .clear
            bottomView.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
            photosViewController.overlayView.bottomStackContainer.insertSubview(bottomView, at: 0) // insert custom

            self.present(photosViewController, animated: true)
        }
}
