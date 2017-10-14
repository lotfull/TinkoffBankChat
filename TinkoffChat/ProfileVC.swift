//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit



struct Profile {
    var name: String
    var info: String
    var image: UIImage?
    
    init(name: String, info: String, image: UIImage? = nil) {
        self.name = name
        self.info = info
        self.image = image
    }
}

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorInit()
        
        logFunctionName()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cornerRadius = (changePhotoButton.frame.height) / 2 + 8
        changePhotoButton.layer.cornerRadius = cornerRadius
        photoImageView.layer.cornerRadius = cornerRadius
    }
    func updateUI() {
        // encoding
        
        //UserDefaults.standard.set(false, forKey: isProfileImageLoaded)
        // TODO: Get_Data_from_file
        if !UserDefaults.standard.bool(forKey: isProfileImageLoaded) {
            let image = UIImage(named: "GaroldWithPain.png")
            let imageData: NSData = UIImageJPEGRepresentation(image!, 1.0)! as NSData
            UserDefaults.standard.set(imageData, forKey: profileImageKey)
        }
        // if !UserDefaults.standard.bool(forKey: )
        // Decode
        let data = UserDefaults.standard.object(forKey: profileImageKey) as! NSData
        let image = UIImage(data: data as Data)
        photoImageView.image = image
        photoImageView.clipsToBounds = true
        editProfileWithGCDButton.layer.borderWidth = 1.0
        editProfileWithGCDButton.layer.cornerRadius = 12.0
        editProfileWithOperationButton.layer.borderWidth = 1.0
        editProfileWithOperationButton.layer.cornerRadius = 12.0
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
            
            //let imageData: NSData = UIImageJPEGRepresentation(image, 1.0)! as NSData
//            UserDefaults.standard.set(imageData, forKey: profileImageKey)
//            UserDefaults.standard.set(true, forKey: isProfileImageLoaded)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func activityIndicatorInit() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    
    // MARK: @IB***
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var editProfileWithGCDButton: UIButton!
    @IBOutlet weak var editProfileWithOperationButton: UIButton!
    @IBAction func editProfileWithGCD(_ sender: Any) {
        // TODO: save_data_GCD
        activityIndicator.startAnimating()
        let queue = DispatchQueue(label: "editProfileWithGCD.queue")
        queue.async {
            let image
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                let filename = getDocumentsDirectory().appendingPathComponent("profile_photo.png")
                try? data.write(to: filename)
            }
        }
        
    }
    @IBAction func editProfileWithOperation(_ sender: Any) {
        // TODO: save_data_GCD
        activityIndicator.startAnimating()
        save_data()
    }
    
    // MARK: Vars and Lets
    let isProfileImageLoaded = "isProfileImageLoaded"
    let isProfileNameLoaded = "isProfileNameLoaded"
    let isProfileInfoLoaded = "isProfileInfoLoaded"
    let profileNameKey = "profileName"
    let profileInfoKey = "profileInfo"
    let profileImageKey = "profileImage"
    var lastMethod: String = "Opening VC"
    var activityIndicator = UIActivityIndicatorView()
    
}


















