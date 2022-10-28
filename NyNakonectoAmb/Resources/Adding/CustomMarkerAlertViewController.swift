//
//  CustomMarkerAlert.swift
//  NyNakonectoAmb
//
//  Created by G412 on 17.10.2022.
//

import UIKit

class CustomMarkerAlert: UIViewController {
    
    @IBOutlet var markerOnTapView: UIView!
    @IBOutlet var markerImageView: UIImageView!
    @IBOutlet var markerTextView: UITextView!
    
    init(){
        super.init(nibName: "CustomMarkerAlert", bundle: Bundle(for: CustomMarkerAlert.self))
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .overCurrentContext
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }//константа цвета пространства за алертом

    /*private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 20
        return alert
    }()
    
    private var myTargetView: UIView?
    
    private var alertImage = UIImage()
    
    func showAlert(with title: String,
                   message: String,
                   on viewController: UIViewController){
        guard let targetView = viewController.view else{
            return
        }//функция вызова алерта на экран
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(alertView)
        
        alertView.frame = CGRect(x: 0,
                                 y: -840,
                                 width: targetView.frame.size.width,
                                 height: 305)
        
        let alertImageView = UIImageView(frame: CGRect(
            x: 20,
            y: -340,
            width: alertView.frame.size.width-50,
            height: alertView.frame.size.width/2))
        alertView.addSubview(alertImageView)
        
        let alertText = UILabel(frame: CGRect(
            x: 20,
            y: -380,
            width: alertImageView.frame.size.width,
            height: alertImageView.frame.size.height))
        alertView.addSubview(alertText)
    }*/
}

