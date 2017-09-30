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
        if let image = loadImageFromPath(path: profileImagePath + ".jpg") {
            print("loaded jpg")
            photoImageView.image = image
        } else if let image = loadImageFromPath(path: profileImagePath + ".png") {
            print("loaded png")
            photoImageView.image = image
        }
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
            saveImage(image: image, path: profileImagePath) ? print("image saved") : print("image not saved")
        } else {
            // Error message here
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    let profileImagePath = "profileImage"
    var lastMethod: String = "Opening VC"
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBAction func editProfileButtonPressed(_ sender: Any) {
    }
    

   /*
    let image = UIImage(named: "myImage")
    let pngImage = UIImagePNGRepresentation(image)
    
    NSUserDefaults.standardUserDefaults().setObject(pngImage, forKey: "image")
    and to retrieve the image:
    
    var retrievedImage = NSUserDefaults.standardUserDefaults().objectForKey("image") as! AnyObject
    Then, to display the image:
    
    imageView.image = UIImage(data: retrievedImage as! NSData)
 */
    
    
    
    // This is how to store an image to a file (much better):
    func saveImage (image: UIImage, path: String ) -> Bool{
        if let pngImageData = UIImagePNGRepresentation(image) {
            do {
                try pngImageData.write(to: URL(fileURLWithPath: profileImagePath + ".png"))
                return true
            } catch {
                return false
            }
            //let result = pngImageData.write(to: URL(fileURLWithPath: profileImagePath + ".png"))
        } else if let jpgImageData = UIImageJPEGRepresentation(image, 1.0) {
                do {
                    try jpgImageData.write(to: URL(fileURLWithPath: profileImagePath + ".jpg"))
                    return true
                } catch {
                    return false
                }
        }
        return false
    }
    
    //You would call it like this:
    
    //Then, to retrieve the image, use this function:
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
    }
    //You can call it like this:
    
    // For more details, take a look at http://helpmecodeswift.com/image-manipulation/saving-loading-images
    
    
    
    
    
}

