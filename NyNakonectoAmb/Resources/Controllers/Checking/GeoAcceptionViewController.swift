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
    var markerImg = UIImage(named: "Illustration")
}

class GeoAcceptionViewController: UIViewController, CLLocationManagerDelegate, AlertAfterSending {
    
    func manageAlert() {
        let alert = UIAlertController(title: "", message: "Метка отправлена на проверку!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
    }//высвечивание сообщения после отправки маркера на сервер
    
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var faqButton: UIButton!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var myMap: MKMapView!
    
    let locationManager = CLLocationManager()
    
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
    }//запрос геопозиции
    
    @objc func dismissAlert(){
        customAlert.dismissAlert()
    }//глобальное объявление функции отмены алерта
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }//функция закрытия клавиатуры при нажатии на VC
    
    @IBAction func didTapBack(){
        self.dismiss(animated: true, completion: nil)
    }//функция выхода из VC по нажатию на кнопку "назад"
    
    @objc func tappedRefresh(sender: UIButton){
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
    }//добавление маркера на текущую геопозицию пользователя
    
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
}//проверка наличия разрешения на использование геолокации

protocol AlertAfterSending{
    func manageAlert()
}//делегирование высвечивания сообщения после отправки функции

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

//ниже представлен класс алерта, который отправляет сообщение на сервер
class DescriptionAlert: NSObject, CLLocationManagerDelegate{
    
    var delegate: AlertAfterSending?//объявление делегирования сообщения после отправки
    
    private var messageLabel: UITextField!//объявление текстфилда, позволяющий запомнить текст, введённый в поле ввода текста
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }//константа цвета пространства за алертом
    
    var checkbox1 = Checkbox(frame: CGRect(
        x: 30,
        y: 115,
        width: 30,
        height: 30))
    
    var checkLabel = UILabel()
    var kostyl = false
    
    @objc func didTapCheckbox(){
        checkbox1.toggle()
        kostyl = !kostyl
        let checkedImage = UIImage(named: "checkmark")
        let checkedYep = UIImageView(image: checkedImage)
        if (kostyl) == true{
            checkLabel.textColor = UIColor(red: 0.942, green: 0.104, blue: 0.266, alpha: 1)
            self.checkbox1.addSubview(checkedYep)
        }
        else{
            checkLabel.textColor = UIColor(red: 0.596, green: 0.596, blue: 0.596, alpha: 1)
            self.checkbox1.willRemoveSubview(checkedYep)
        }
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()//описание пространства за алертом
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 20
        return alert
    }()//описание алерта
    
    private var myTargetView: UIView?
    
    @objc func showAlert(with title: String,
                   message: String,
                   on viewController: UIViewController){
        guard let targetView = viewController.view else{
            return
        }//функция вызова алерта на экран
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        
        alertView.frame = CGRect(
            x: 40,
            y: -300,
            width: targetView.frame.size.width-60,
            height: 220)
        
        //титульная надпись на алерте
        let titleLabel = UILabel(frame: CGRect(
            x: 45,
            y: 5,
            width: alertView.frame.size.width,
            height: 70))
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.font = titleLabel.font.withSize(18)
        titleLabel.textColor = .black//UIColor(red: CGFloat(152.0/255.0), green: CGFloat(152.0/255.0), blue: CGFloat(152.0/255.0), alpha: 0.8)
        titleLabel.layer.opacity = 1
        alertView.addSubview(titleLabel)
        
        //поле ввода алерта
        messageLabel = UITextField(frame: CGRect(
            x: 30,
            y: 60,
            width: alertView.frame.size.width - 65,
            height: alertView.frame.size.height*0.2))
        messageLabel.returnKeyType = .done
        messageLabel.autocapitalizationType = .sentences
        messageLabel.autocorrectionType = .default
        messageLabel.font = messageLabel.font?.withSize(13.5)
        messageLabel.textAlignment = .left
        messageLabel.layer.cornerRadius = 20
        messageLabel.borderStyle = UITextField.BorderStyle.roundedRect
        let borderColor = CGColor(red: 152, green: 152, blue: 152, alpha: 0.8)
        messageLabel.layer.borderColor = borderColor
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.myTargetView!.endEditing(true)
            return false
        }
        alertView.addSubview(messageLabel)
        
        //кнопка "отправить" на алерте
        let buttonSend = UIButton()
        buttonSend.frame = CGRect(
            x: 0,
            y: alertView.frame.size.height - 65,
            width: alertView.frame.size.width,
            height: 70)
        buttonSend.setTitle("Отправить", for: .normal)
        buttonSend.setTitleColor(.white, for: .normal)
        buttonSend.backgroundColor = UIColor(red: CGFloat(149.0/255.0), green: CGFloat(227.0/255.0), blue: CGFloat(117.0/255.0), alpha: 0.8)
        alertView.addSubview(buttonSend)
        buttonSend.addTarget(
            self,
            action: #selector(dismissAlert),
            for: .touchUpInside)
        
        //tableView для чекбокса
        checkbox1 = Checkbox(frame: CGRect(
            x: 30,
            y: 115,
            width: messageLabel.frame.size.width*0.09,
            height: messageLabel.frame.size.height*0.5))
        checkLabel = UILabel(frame: CGRect(
            x: 65,
            y: 104,
            width: messageLabel.frame.size.width,
            height: messageLabel.frame.size.height
        ))
        checkLabel.text = "Сохранить фото"
        checkLabel.textColor = UIColor(red: 0.596, green: 0.596, blue: 0.596, alpha: 1)
        checkLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckbox))
        checkbox1.addGestureRecognizer(gesture)
        alertView.addSubview(checkbox1)
        alertView.addSubview(checkLabel)
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                
                self.backgroundView.alpha = Constants.backgroundAlphaTo
                
            }, completion: {done in
                if done{
                    UIView.animate(
                        withDuration: 0.25,
                        animations: {
                            self.alertView.center = targetView.center
                        })
                }
            })
    }//анимация появления алерта
    
    //ниже описана функция "задвигания" алерта
    @objc func dismissAlert(){
        
        delegate?.manageAlert()//см. 156
        
        guard let targetView = myTargetView else{
            return
        }
        
        let locationManager = CLLocationManager()
        
        //параметры по отправке на сервер---
        let des = self.messageLabel.text
        let lati = String(locationManager.location?.coordinate.latitude ?? 0.0)
        let longti = String(locationManager.location?.coordinate.longitude ?? 0.0)
        let coords = String("\(lati), \(longti)")
        var URLmy : String!
        URLmy = "https://tagproject-api.sfedu.ru/api/v1/map/markers/upload/"
        let deviceName = UIDevice.current.name
        
        let parameters: [String: Any] = [
            "name": "\(deviceName)",
            "description": "\(String(describing: self.messageLabel.text))",
            "gps": "\(coords)",
            "marker_type": "1",
            "image": "/9j/4AAQSkZJRgABAQEAYABgAAD/2wCEAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf/CABEIAAEAAQMBIgACEQEDEQH/xAAUAAEAAAAAAAAAAAAAAAAAAAAK/9oACAEBAAAAAH8f/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAhAAAAB//8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAxAAAAB//8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPwB//8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAgEBPwB//8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAgBAwEBPwB//9k="
        ]//---
        
        AF.upload(multipartFormData: {multipartFormData in
            for _ in parameters{
                multipartFormData.append(deviceName.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "name")
                multipartFormData.append(des!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "description")
                multipartFormData.append(coords.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "gps")
                multipartFormData.append("0".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "marker_type")
                multipartFormData.append(baseImg.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "image")
            }
            if self.checkbox1.isChecked == true {
                UIImageWriteToSavedPhotosAlbum(savedImage!, nil, nil, nil)
            }
            
        }, to: URLmy, method: .post)
        .uploadProgress{progress in
            print(CGFloat(progress.fractionCompleted))
        }.response{ response in
            
            if (response.error == nil){
                var responseStr : String!
                responseStr = ""
                if (response.data != nil){
                    responseStr = String(bytes: response.data!, encoding: .utf8)
                }
                else {
                    responseStr = response.response?.description
                }
                
                print(responseStr ?? "")
                print(response.response?.statusCode ?? 0.0)
                var responseData: NSData
                responseData = response.data! as NSData
                let iDataLength = responseData.length
                print ("size: \(iDataLength) bytes")
            }
        }//запрос выгрузки и выгрузка маркера на сервер, вывод в лог результатов запроса
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.alertView.frame = CGRect(
                    x: 40,
                    y: targetView.frame.size.height,
                    width: targetView.frame.size.width-80,
                    height: 300)
            }, completion: {done in
                if done{
                    UIView.animate(withDuration: 0.25, animations: {
                        self.backgroundView.alpha = 0
                    }, completion: { done in
                        if done{
                            self.alertView.removeFromSuperview()
                            self.backgroundView.removeFromSuperview()
                        }
                    })
                }
            })//анимация "задвигания" алерта
    }
}
