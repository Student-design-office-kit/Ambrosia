//
//  ViewController.swift
//  NyNakonectoAmb
//
//  Created by G412 on 03.03.2022.
//

import UIKit
import Alamofire
import CoreLocation

var markerList: [CLLocationCoordinate2D] = []

public func setAllMarkers(){
    
}

struct GetArrs: Decodable{
    var id: Int
    var street: String
    var name: String
    var description: String
    var gps: String
    var image: String
    var getImage: String
    var createdOn: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case street
        case name
        case description
        case gps
        case image
        case getImage = "get_image"
        case createdOn = "created_on"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //        refreshButton.backgroundColor = UIColor(red: CGFloat(149.0/255.0), green: CGFloat(227.0/255.0), blue: CGFloat(117.0/255.0), alpha: 0.8)
    //        refreshButton.layer.cornerRadius = 12
            
     //       faqButton.backgroundColor = UIColor(red: CGFloat(149.0/255.0), green: CGFloat(227.0/255.0), blue: CGFloat(117.0/255.0), alpha: 0.8)
     //       faqButton.layer.cornerRadius = 12
    
    
    //"tagproject-api.sfedu.ru/api/v1/map/markers"
    
    
    /*extension GetArrs {
        var location: CLLocationCoordinate2D? {
            let coordinates = gps.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .map { CLLocationDegrees($0) }
            guard coordinates.count > 1, let latitude = coordinates[0], let longitude = coordinates[1] else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }*/
    
    /*extension MarkerViewController: MKMapViewDelegate {
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         let isUserLocationAnnotation = annotation.isKind(of: MKUserLocation.self)
         let reuseIdentifier = isUserLocationAnnotation ? "UserLocationAnnotation" : "MarkerAnnotation"
         
         var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
         if annotationView == nil {
             annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
             annotationView?.canShowCallout = true
             annotationView?.image = UIImage(systemName: isUserLocationAnnotation ? "person.circle.fill" : "mappin.circle.fill")
         } else {
             annotationView?.annotation = annotation
         }
         return annotationView
     }
    }*/
    
    /*            func GetJSON() {
                    let url = "https://tagproject-api.sfedu.ru/api/v1/map/markers"
                    AF.request(url, method: .get).responseData { [self] response in
                        switch response.result {
                        case .success(_):
                            JSON1 = JSON(response.value!)
                            print (JSON1![0])
                            var gettingJSON = Getting(from: JSON1![0])
                        case .failure:
                            print("Ошибка \(String(describing: response.error))")
                      }
                    }
                  }
    */
    
    /*customAlert.showAlert(
        with: "Test",
        message: "Test Alert",
        on: self)
    
    func dismissAlert(){
        customAlert.dismissAlert()
    }*/
    
    /*        let button = UIButton(frame: CGRect(
                x: 0,
                y: alertView.frame.size.height-50,
                width: alertView.frame.size.width,
                height: 50))
            button.setTitle("Dismiss", for: .normal)
            button.setTitleColor(.link, for: .normal)
            button.addTarget(
                self,
                action: #selector(dismissAlert),
                for: .touchUpInside)
            alertView.addSubview(button)*/
    
    /* protocol MapinDialogViewDelegate: AnyObject {
        func createPinDescr(text: String)
    }

    final class MapPinDialogueView: UIView {
        private let lblTitle: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingIntoMask = true
            lbl.text = "Опишите метку"
    //        тут короче цвет текста, прочая дрочь
            return lbl
        }()

        private let textField: UITextField = {
            let tf = UITextField()
    //        всякая ui дрочь
            tf.translatesAutoresizingIntoMask = false
            return tf
        }()

        private let createBtn: UIButton = {
    //        все тоже самое
        }

        private var delegate: MapPinDialogueViewDelegate?

        func configView(with delegate: MapinDialogViewDelegate?) {
            self.delegate = delegate
            createBtn.addTarget(self, #selector(creteBtnTapped), on: .touchUpInside)

            self.addSubview(lblTitle)
            self.addSubview(textField)
            self.addSubview(createBtn)

            NSLayoutConstraint.activate [
                lblTitle.leftAnchor.constraint(to: self.leftAnchor, constant: /*размер констрейна*/),
                lblTitle.rightAnchor.constraint(to: self.rightAnchor, constant: /*размер констрейна*/)

                /*всего 4 якора: лево, верх, право, низ. Это тот же констрейнт что в сториборде пуляешь по сторонам
                технология uiПеременная.якорь.constraint(to: вьюКудаКинаешьКонстрейнт.якорь, constant: величина)
                лепи минус перед константой если вью будет вылезать за границы, т.е. констрейнт не сработал. Такое бывает

                а вот так лепишь к не self, а другим вьюхам*/
                createBtn.topAnchor.constraint(to: textField.bottomAnchor, constant: 20)
            ] // это ты добавил и закрепил сабвьюхи на dialogView

        }

        @objc func createBtnTapped() {
            delegate?.createPinDescr(text: textField.text)
        }
    }

    class GeoAcceptionViewController {
        
        private let pinDescrView: MapPinDialogueView!

        overridue func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }

        func setupUI() {
            ...
            pinDescrView = MapPinDialogueView()
            pinDescrView.translatesAutoresizingIntoMask = false
            pinDescrView.widthAnchor.equalTo(constant: 200).isActive = true
            pinDescrView.heightAnchor.equalTo(constant: 200).isActive = true
            pinDescrView.centerXAnchor.constraint(to: self.view.centerXAnchor).isActive = true
            pinDescrView.centerYAnchor.constraint(to: self.view.centerYAnchor).isActive = true
            pinDescrView.configView(with: self)
            self.view.addSubview(pinDescrView)
        }

    }

    extension GeoAcceptionViewController: MapPinDialogueViewDelegate {
        func createPinDescr(text: String) {
            ... делаешь че те надо
        }
    }*/
    
    /*final class MapPinDialogueView: UIView{
        
        struct Constants {
            static let backgroundAlphaTo: CGFloat = 0.6
        }
        
        private let backgroundView: UIView = {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .black
            backgroundView.alpha = 0
            return backgroundView
        }()
        
        private let alertView: UIView = {
            let alert = UIView()
            alert.backgroundColor = .white
            alert.layer.masksToBounds = true
            alert.layer.cornerRadius = 12
            return alert
        }()
        
        func showAlert(with title: String,
                       message: String,
                       on viewController: UIViewController){
            guard let targetView = viewController.view else{
                return
            }
            
    //    private var myTargetView: UIView?
    //    myTargetView = targetView
            
            backgroundView.frame = targetView.bounds
            targetView.addSubview(backgroundView)
            
            targetView.addSubview(alertView)
            alertView.frame = CGRect(
                x: 40,
                y: -300,
                width: targetView.frame.size.width-80,
                height: 300)
            
            let titleLabel = UILabel(frame: CGRect(
                x: 0,
                y: 0,
                width: alertView.frame.size.width,
                height: 80))
            titleLabel.text = title
            titleLabel.textAlignment = .center
            alertView.addSubview(titleLabel)
            
            let messageLabel = UILabel(frame: CGRect(
                x: 0,
                y: 80,
                width: alertView.frame.size.width,
                height: 170))
            messageLabel.numberOfLines = 0
            messageLabel.text = message
            messageLabel.textAlignment = .center
            alertView.addSubview(messageLabel)
            
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
        }
    }*/
    
    /*            UIView.animate(
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
                    })*/
    
    /*@objc func dismissAlert(){
                
                guard let targetView = myTargetView else{
                    return
                }
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
                                })
                print("est' nazhatie")

            }
        }*/
    
class MyAlert{
        
        struct Constants {
            static let backgroundAlphaTo: CGFloat = 0.6
        }
        
        private let backgroundView: UIView = {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .black
            backgroundView.alpha = 0
            return backgroundView
        }()
        
        private let alertView: UIView = {
            let alert = UIView()
            alert.backgroundColor = .white
            alert.layer.masksToBounds = true
            alert.layer.cornerRadius = 12
            return alert
        }()
        
        private var myTargetView: UIView?
        
        func showAlert(with title: String,
                       message: String,
                       on viewController: UIViewController){
            guard let targetView = viewController.view else{
                return
            }
            
        myTargetView = targetView
            
            backgroundView.frame = targetView.bounds
            targetView.addSubview(backgroundView)
            
            targetView.addSubview(alertView)
            alertView.frame = CGRect(
                x: 47,
                y: -250.4,
                width: targetView.frame.size.width-94,
                height: targetView.frame.size.height-507)
            
            let titleLabel = UILabel(frame: CGRect(
                x: 0,
                y: 0,
                width: alertView.frame.size.width,
                height: 80))
            titleLabel.text = title
            titleLabel.textAlignment = .center
            alertView.addSubview(titleLabel)
            
            let messageLabel = UILabel(frame: CGRect(
                x: 0,
                y: 80,
                width: alertView.frame.size.width,
                height: 170))
            messageLabel.numberOfLines = 0
            messageLabel.text = message
            messageLabel.textAlignment = .center
            alertView.addSubview(messageLabel)
            
            let button = UIButton(frame: CGRect(
                x: 0,
                y: alertView.frame.size.height-50,
                width: alertView.frame.size.width,
                height: 50))
            button.setTitle("Dismiss", for: .normal)
            button.setTitleColor(.link, for: .normal)
            button.addTarget(
                self,
                action: #selector(dismissAlert),
                for: .touchUpInside)
            alertView.addSubview(button)
            
            
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
        }
        
        @objc func dismissAlert(){
            
            guard let targetView = myTargetView else{
                return
            }
            
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
                })
        }
    }
}
