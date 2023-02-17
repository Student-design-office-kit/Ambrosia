//
//  DescriptionAlert.swift
//  NyNakonectoAmb
//
//  Created by СКБ on 30.10.2022.
//

import UIKit
import CoreLocation
import Alamofire

class DescriptionAlert: NSObject, CLLocationManagerDelegate{

    var delegate: AlertAfterSending?//объявление делегирования сообщения после отправки

    private var messageLabel: UITextField!//объявление текстфилда, позволяющий запомнить текст, введённый в поле ввода текста

    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    var checkbox1 = Checkbox(frame: CGRect(
        x: 30,
        y: 115,
        width: 30,
        height: 30))

    var checkLabel = UILabel()
    var kostyl = false

    //tapping checkbox action
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

    //declaring and setting up background view
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()

    //declaring and setting up alert view
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 20
        return alert
    }()

    private var myTargetView: UIView?

    //showing alert on the screen
    @objc func showAlert(with title: String,
                   message: String,
                   on viewController: UIViewController){
        guard let targetView = viewController.view else{
            return
        }

        myTargetView = targetView

        backgroundView.frame = targetView.bounds

        targetView.addSubview(backgroundView)

        targetView.addSubview(alertView)
        
        //alert view
        alertView.frame = CGRect(
            x: 40,
            y: -300,
            width: targetView.frame.size.width-60,
            height: 220)

        //alert title label
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

        //alert input
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

        //alert "send" button
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
        
        //alert showing up animation
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

    //alert vanishing
    @objc func dismissAlert(){

        delegate?.manageAlert()//см. 156

        guard let targetView = myTargetView else{
            return
        }

        let locationManager = CLLocationManager()

        //data to server parameters
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
        ]

        //uploading marker to server, showing results in console
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
        }

        //alert vanishing animation
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
