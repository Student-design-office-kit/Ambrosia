//
//  PopUpViewController.swift
//  NyNakonectoAmb
//
//  Created by G412 on 18.03.2022.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBAction func showAlertButtonTapped(_ sender: UIButton) {

           // create the alert
           let alert = UIAlertController(title: "UIAlertController", message: "Would you like to continue learning how to use iOS alerts?", preferredStyle: UIAlertController.Style.alert)

           // add the actions (buttons)
           alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
           alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

           // show the alert
           self.present(alert, animated: true, completion: nil)
       }
   }
