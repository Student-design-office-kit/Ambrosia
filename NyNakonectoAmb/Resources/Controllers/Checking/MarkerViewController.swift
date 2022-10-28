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

var images: [String] = []

let popUpAlert = CustomMarkerAlert()

class MarkerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myMap: MKMapView!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var faqButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    private var annotations: [MKPointAnnotation] = []//массив маркеров
    
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
                    var markerImage: UIImage? {
                        let imgLink:String = marker.image
                        var mI = UIImage(named: "tag")
                        //let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory)
                        AF.request(imgLink).responseImage { response in
                            debugPrint(response)
                            if case .success(let image) = response.result {
                                mI = image
                            }
                        }
                        return mI
                    }
                    let pin = MyAnnotation()
                    pin.coordinate = place
                    pin.title = marker.description
                    pin.markerImg = markerImage
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
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.distanceFilter = kCLDistanceFilterNone
        }
    }
    
    @objc func tappedRefresh(sender: UIButton){
        let allAnnotations = self.myMap.annotations
        self.myMap.removeAnnotations(allAnnotations)
        getJSON()
        let alert = UIAlertController(title: "", message: "Карта очагов сорной растительности была обновлена!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }//действие на кнопку обновления
    
    @objc func tappedFAQ(sender: UIButton){
        let alert = UIAlertController(title: "", message: "Вы можете помогать администрации бороться с сорной растительностью, фотографируя кусты амброзии и создавая метки её произростания на карте города", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }//действие на кнопку вопросика
    
    @objc func tappedMarker(){
        let alert = CustomMarkerAlert()
        alert.show()
    }
    
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

//замена дефолтных маркеров на кастомные
extension MarkerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let isUserLocationAnnotation = annotation.isKind(of: MKUserLocation.self)
        let reuseId = isUserLocationAnnotation ? "CurrentUserLocation" : "MarkerAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        let tagImage = UIImage(named: "tag.png")
        if annotationView == nil {
            /*switch(reuseId) {
            case "CurrentUserLocation":
                annotationView = MKUserLocationView()
                annotationView?.canShowCallout = false
            case "MarkerAnnotation":
                annotationView?.image = tagImage
                annotationView?.canShowCallout = true
            default:
                return nil
            }*/
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = isUserLocationAnnotation ? false : true
            annotationView?.image = isUserLocationAnnotation ? UIImage(systemName: "person.crop.circle.badge") : tagImage
            annotationView?.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            let rightButton = UIButton(type: .contactAdd)
            rightButton.addTarget(self,
                                  action: #selector(tappedMarker),
                                  for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
