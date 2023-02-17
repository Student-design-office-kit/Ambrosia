//
//  GeoAcceptionViewController.swift
//  NyNakonectoAmb
//
//  Created by G412 on 03.03.2022.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import Alamofire

let customAlert = DescriptionAlert()

class MyAnnotation: MKPointAnnotation{
    var reuseIdentifier: String = ""
    var id: Int = 0
}

class GeoAcceptionViewController: UIViewController, CLLocationManagerDelegate, AlertAfterSending {
    
    //message after sending marker
    func manageAlert() {
        let alert = UIAlertController(title: "", message: "Метка отправлена на проверку!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var faqButton: UIButton!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var myMap: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //getting JSON data from server
    func getJSON() {
        let url = "https://tagproject-api.sfedu.ru/api/v1/map/markers"
        AF.request(url, method: .get).responseDecodable(of: [GetArrs].self){ [self] dataResponse in
            switch (dataResponse.result) {
            case .success(let markers):
                for marker in markers {
                    var mesto: CLLocationCoordinate2D {
                        let strings:[String] = marker.gps.components(separatedBy: ", ")
                        let lattitude: Double = Double(strings[0]) ?? 12
                        let longitutde = Double(strings[1]) ?? 12
                        return CLLocationCoordinate2D(latitude: lattitude, longitude: longitutde)
                    }
                    let pin = MyAnnotation()
                    pin.coordinate = mesto
                    pin.id = marker.id
                    myMap.addAnnotation(pin)
                }
                break
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        
        customAlert.showAlert(
            with: "Опишите метку",
            message: "",
            on: self)//костыль
        
        super.viewDidLoad()
        
        getJSON()
        
        customAlert.showAlert(
            with: "Опишите метку",
            message: "",
            on: self)//вызов алёрта
        
        customAlert.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        backButton.addTarget(self,
                             action: #selector(didTapBack),
                             for: .touchUpInside)
        refreshButton.addTarget(self,
                                action: #selector(tappedRefresh),
                                for: .touchUpInside)
        faqButton.addTarget(self,
                            action: #selector(tappedFAQ),
                            for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.distanceFilter = kCLDistanceFilterNone
        }
        
        myMap.showsUserLocation = true
    }
    
    //declaring dismiss alert function
    @objc func dismissAlert(){
        customAlert.dismissAlert()
    }
    
    //hiding keyboard when tapping on view
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //back button action
    @IBAction func didTapBack(){
        self.dismiss(animated: true, completion: nil)
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
    
    //setting up location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            manager.stopUpdatingLocation()
            
            let coordinates = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            let span = MKCoordinateSpan (latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinates, span: span)
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

//protocol of showing message function after sending
protocol AlertAfterSending{
    func manageAlert()
}

extension GeoAcceptionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "MarkerAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "tag.png")
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
