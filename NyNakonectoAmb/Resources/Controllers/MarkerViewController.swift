//
//  MarkerViewController.swift
//  NyNakonectoAmb
//
//  Created by G412 on 04.07.2022.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import Alamofire
import AlamofireImage

//button inheritant just to add an ID
class ButtonInheritant : UIButton {
    var id: String = ""
}

//main map view
class MarkerViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var faqButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    private var annotations: [MKPointAnnotation] = []
    
    //getting JSON data from server
    func getJSON() {
        let url = "https://tagproject-api.sfedu.ru/api/v1/map/markers"
        AF.request(
            url,
            method: .get).responseDecodable(of: [GetArrs].self){ [self] dataResponse in
                switch (dataResponse.result) {
                case .success(let markers):
                    for marker in markers {
                        var place: CLLocationCoordinate2D {
                            let strings:[String] = marker.gps.components(separatedBy: ",")
                            let trimmed = strings.map { $0.trimmingCharacters(in: .whitespaces)}
                            let lattitude: Double = Double(trimmed[0]) ?? 12
                            let longitutde = Double(trimmed[1]) ?? 12
                            return CLLocationCoordinate2D(latitude: lattitude, longitude: longitutde)
                        }
                        arrOfMarkers.append(marker)
                        let pin = MyAnnotation()
                        pin.coordinate = place
                        pin.title = String(marker.id)
                        myMap.addAnnotation(pin)
                        annotations.append(pin)
                    }
                    break
                case .failure(let error):
                    print("ERROR: \(error)")
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJSON()
        
        myMap.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        myMap.layer.cornerRadius = 12
        
        refreshButton.addTarget(self,
                                action: #selector(tappedRefresh),
                                for: .touchUpInside)
        faqButton.addTarget(self,
                            action: #selector(tappedFAQ),
                            for: .touchUpInside)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.distanceFilter = kCLDistanceFilterNone
        }
    }
    
    //refresh button action
    @objc func tappedRefresh(sender: UIButton) {
        let allAnnotations = self.myMap.annotations
        arrOfMarkers = []
        self.myMap.removeAnnotations(allAnnotations)
        getJSON()
        let alert = UIAlertController(title: "", message: "Карта очагов сорной растительности была обновлена!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    //FAQ button action
    @objc func tappedFAQ(sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Вы можете помогать администрации бороться с сорной растительностью, фотографируя кусты амброзии и создавая метки её произростания на карте города", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    //tapping on marker
    @objc func tappedMarker(sender: ButtonInheritant) {
        let alerty = MarkerPopUpView()
        alerty.getID(title: sender.id)
        if #available(iOS 15.0, *) {
            if let sheet = alerty.sheetPresentationController {
                sheet.detents = [.medium(), .medium()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 30
                
            }
        } else {
            // Fallback on earlier versions
        }
        self.present(alerty, animated: true)
    }
    
    //setting up location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            manager.stopUpdatingLocation()
            
            let coordinates = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            let span = MKCoordinateSpan (latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinates, span: span)
            let maxZoomOut = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
            myMap.setCameraZoomRange(maxZoomOut, animated: true)
            myMap.setRegion(region, animated: true)
            
            /*let pin = MKPointAnnotation()
             pin.coordinate = coordinates
             pin.title = "Эй, я здесь!"
             myMap.addAnnotation(pin)*/
        }
    }
    
    //location authorization verification
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//default markers -> custom ones
extension MarkerViewController: MKMapViewDelegate {
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let isUserLocationAnnotation = annotation.isKind(of: MKUserLocation.self)
        let reuseId = isUserLocationAnnotation ? "CurrentUserLocation" : "MarkerAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        let tagImage = UIImage(named: "tag.png")
        
        if annotationView == nil {
            
            switch(reuseId) {
            case "CurrentUserLocation":
                annotationView = MKUserLocationView()
                annotationView?.canShowCallout = false
            case "MarkerAnnotation":
                annotationView?.image = tagImage
                annotationView?.canShowCallout = true
            default:
                return nil
            }
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = isUserLocationAnnotation ? false : true
            annotationView?.image = isUserLocationAnnotation ? UIImage(systemName: "person.crop.circle.badge") : tagImage
            annotationView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            let rightButton = ButtonInheritant(type: .contactAdd)
            rightButton.id = (annotation.title ?? "253") ?? "252"
            rightButton.addTarget(self,                                    action: #selector(tappedMarker),
                                  for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
        }
        
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
