//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logFunctionName()
        nameLabel.text = "Garold"
        changePhotoButton.layer.cornerRadius = changePhotoButton.frame.width / 2
        photoImageView.layer.cornerRadius = changePhotoButton.frame.width / 2
        photoImageView.clipsToBounds = true
        editProfileButton.layer.borderWidth = 1.0
        editProfileButton.layer.cornerRadius = 8.0
    }
    func logFunctionName(method: String = #function) {
        print("Completed ProfileVC.\(lastMethod)\nStarted ProfileVC.\(method)")
        lastMethod = method
    }
    
    @IBAction func changePhotoAction(_ sender: Any) {
        print("changePhotoAction")
    }
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        button.titleLabel?.text = "11"
        
        // let button: UIButton = (sender as? UIButton) ?? UIButton()
    }
    
    var lastMethod: String = "Opening VC"

}

