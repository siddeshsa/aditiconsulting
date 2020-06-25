//
//  AddViewController.swift
//  MyReminders//  MyReminders
//
//  Created by mac on 25/06/20.
//  Copyright © 2020 mac. All rights reserved.
//
import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!

    public var completion: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
       // self.navigationController?.navigationBar.isHidden = true
       
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func savePressed(_ sender: Any) {
    
    if let titleText = titleField.text, !titleText.isEmpty,
              let bodyText = bodyField.text, !bodyText.isEmpty {

              completion?(titleText, bodyText)

          }
    }
    @objc func didTapSaveButton() {
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text, !bodyText.isEmpty {

            completion?(titleText, bodyText)

        }
    }

  

}
