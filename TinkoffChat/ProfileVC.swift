//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        if editProfileButton != nil {
            print("***", editProfileButton.frame, #function)
        } else {
            print("Couldn't print editProfileButton.frame because it is forceUnwrapped but nil at start of init(). It gets reference to UIButton object in loadView.")
        }
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logFunctionName()
        updateUI()
        print("*** frame: ", editProfileButton.frame, "***") // frame here is scaled for iphone SE(or what device in storyboard)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("*** frame: ", editProfileButton.frame, "***") // frame here is scaled for iphone 8(or what device in simulator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cornerRadius = (changePhotoButton.frame.height) / 2
        changePhotoButton.layer.cornerRadius = cornerRadius
        photoImageView.layer.cornerRadius = cornerRadius
    }
    
    func updateUI() {
        photoImageView.clipsToBounds = true
        editProfileButton.layer.borderWidth = 1.0
        editProfileButton.layer.cornerRadius = 12.0
    }
    
    func logFunctionName(method: String = #function) {
        print("Completed ProfileVC.\(lastMethod)\nStarted ProfileVC.\(method)")
        lastMethod = method
    }
    
    @IBAction func changePhotoAction(_ sender: Any) {
        print("changePhotoAction")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false

        let chooseActionSheet = UIAlertController(title: "Library or Camera?", message: "Choose a photo from Library or take new photo", preferredStyle: .actionSheet)
        
        chooseActionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Photo Library not available")
            }
        }))
        chooseActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        chooseActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(chooseActionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = image
        } else {
            // Error message here
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

