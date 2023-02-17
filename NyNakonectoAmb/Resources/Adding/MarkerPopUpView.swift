//
//  MarkerPopUpView.swift
//  NyNakonectoAmb
//
//  Created by G412 on 15.02.2023.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

//pop up view for wheen you touch the marker
class MarkerPopUpView: UIViewController {
    
    var markerImage = UIImageView(frame: CGRect(
        x: 80,
        y: 30,
        width: 200,
        height: 200))
    
    var streetNameView = UITextView(frame: CGRect(
        x: 30,
        y: 250,
        width: 300,
        height: 160))
    
    var id = "254"
    
    func getID(title: String) {
        id = title
    }
    
    //getting photo from sever
    func getImage(title: String) {
        var url = String()
        for marker in arrOfMarkers {
            if (marker.id) == Int(title) {
                url = marker.getImage
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                let pext = NSAttributedString(string: marker.street,
                                              attributes: [NSAttributedString.Key.paragraphStyle:style])
                streetNameView.attributedText = pext
                streetNameView.text = marker.street
            }
        }
        AF.request(url).responseImage { response in
            debugPrint(response)
            if case .success(let image) = response.result {
                self.markerImage.image = image.af.imageRounded(withCornerRadius: 16)
                self.markerImage.layer.cornerRadius = 12
                print ("фото успешно скачано")
            }
            else{
                self.markerImage.image = UIImage(named: "Illustration")
                self.markerImage.layer.cornerRadius = 12
                let error = response.error
                print ("ERROR: \(String(describing: error))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage(title: id)
        self.view.backgroundColor = .white
        self.view.addSubview(markerImage)
        self.view.addSubview(streetNameView)
    }
    
}
