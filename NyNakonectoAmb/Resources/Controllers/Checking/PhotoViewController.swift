//
//  ViewController.swift
//  AppForAmb
//
//  Created by G412 on 02.02.2022.
//

import UIKit

var baseImg = "?"
var savedImage = UIImage(named: "Illustration")

class PhotoViewController: UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.backgroundColor = UIColor(red: CGFloat(149.0/255.0), green: CGFloat(227.0/255.0), blue: CGFloat(117.0/255.0), alpha: 0.8)
        button.setTitle("Сделать Фото", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 12
    }
    
    @IBAction func didTapButton(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}//размер фотографии

func compressImage(image: UIImage) -> UIImage {
        let resizedImage = image.aspectFittedToHeight(200)
        resizedImage.jpegData(compressionQuality: 0.5)

        return resizedImage
}//сжатие изображения в пять раз

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }//выбор фотографии
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard var image =  info[UIImagePickerController.InfoKey.editedImage]as?
                UIImage else{
                    return
                }
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = pickedImage
        }//сохранение конечной фотографии
        
        image = compressImage(image: image)
        
        func baseEncoding(img: UIImage) -> String{
            return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        }//uiimage -> base64 image
        
        baseImg = baseEncoding(img: image )
        savedImage = image
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let GeoAcceptionViewController = storyBoard.instantiateViewController(withIdentifier: "Geo Acception View Controller") as! GeoAcceptionViewController
        self.present(GeoAcceptionViewController, animated:true, completion:nil)
        
        let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imgData.count
        print("Размер фотки составляет", Double(imageSize) / 1000.0, "КБ")
    }
}




