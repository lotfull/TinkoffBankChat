//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol ProfileDelegate: class {
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void)
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void) -> Bool
}

class ProfileViewController: UIViewController {
    
    // MARK: Main funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        newChanges = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cornerRadius == 0 {
            cornerRadius = (changeImageButton.bounds.size.width) / 2 // + 4
        }
        changeImageButton.layer.cornerRadius = cornerRadius
        imageImageView.layer.cornerRadius = cornerRadius
    }
    
    func loadProfile() {
        activityIndicator.startAnimating()
        managerGCD.loadProfile { (profile, error) in
            
        }
    }
    
    func updateUI() {
        // TODO: Get_Data_from_file
//        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Any?] {
//            profile = array
//            if let image = profile[image] as? UIImage?,
//                let name = profile[name] as? String?,
//                let info = profile[info] as? String? {
//                imageImageView.image = image
//                nameTextField.text = name
//                infoTextField.text = info
//            }
//        }

        imageImageView.clipsToBounds = true
        editProfileWithGCDButton.layer.borderWidth = 1.0
        editProfileWithGCDButton.layer.cornerRadius = 12.0
        editProfileWithOperationButton.layer.borderWidth = 1.0
        editProfileWithOperationButton.layer.cornerRadius = 12.0
    }
    
    // MARK: Image funcs
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func insertNewObject(sender: Any?) {
        NSKeyedArchiver.archiveRootObject(profile, toFile: filePath)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: @IBActions
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeImageAction(_ sender: Any) {
        print("changeImageAction")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        let chooseActionSheet = UIAlertController(title: "Library or Camera?", message: "Choose a image from Library or take new image", preferredStyle: .actionSheet)
        chooseActionSheet.addAction(UIAlertAction(title: "Image Library", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.imageLibrary) {
                imagePickerController.sourceType = .imageLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Image Library not available")
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
    
    
    @IBAction func somethingChanged() {
        if !newChanges {
            newChanges = true
            editProfileWithGCDButton.isEnabled = true
            editProfileWithOperationButton.isEnabled = true
        }
    }
    
    // TODO: Move View when keyboard show
    @IBAction func editProfileWithGCD(_ sender: Any?) {
        activityIndicator.startAnimating()
        let image = self.imageImageView.image as Any?
        let name = self.nameTextField.text as Any?
        let info = self.infoTextField.text as Any?
        
        if managerGCD.saveProfile([image, name, info], completion: nil) {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            newChanges = false
            editProfileWithGCDButton.isEnabled = false
            editProfileWithOperationButton.isEnabled = false
            let alert = UIAlertController(title: "Данные сохранены", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.editProfileWithGCD(nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func editProfileWithOperation(_ sender: Any) {
        //instanceOperation.
        editProfileWithGCD(self)
    }
    
    // MARK: @IBOutlets
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var editProfileWithGCDButton: UIButton!
    @IBOutlet weak var editProfileWithOperationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Vars and Lets
    private var profile: Profile!
    private var changedProfile: Profile! {
        didSet {
            saveButtonsEnableIf(changedProfile != profile)
            updateUI()
        }
    }
    private let managerGCD = GCDDataManager()
    private let managerOperation = OperationDataManager()

    private func saveButtonsEnableIf(_ bool: Bool) {
        editProfileWithGCDButton.isEnabled = bool
        editProfileWithOperationButton.isEnabled = bool
    }
    
    var newChanges = false
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return (url.appendingPathComponent("objectFile")?.path)!
    }
    var lastMethod: String = "Opening VC"
    var keyboardSize: CGRect? = nil
    var show: CGFloat = 1.0
    var cornerRadius: CGFloat = 0.0
    var activeTextField: UITextField?
    
    let isProfileImageLoaded = "isProfileImageLoaded"
    let isProfileNameLoaded = "isProfileNameLoaded"
    let isProfileInfoLoaded = "isProfileInfoLoaded"
    let profileNameKey = "profileName"
    let profileInfoKey = "profileInfo"
    let profileImageKey = "profileImage"
    let image = 0, name = 1, info = 2
}

extension ProfileViewController {
    @objc func keyboardUp(notification: Notification) {
        show = 1.0
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.bounds.origin.y += (keyboardFrame.height - self.editProfileWithGCDButton.bounds.height * 3 )
        })
    }
    
    @objc func keyboardDown(notification: Notification) {
        show = -1.0
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.bounds.origin.y -= (keyboardFrame.height - self.editProfileWithGCDButton.bounds.height * 3 )
        })
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageImageView.image = image
            somethingChanged()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if activeTextField == nameTextField {
                changedProfile = changedProfile.copyWithChanged(name: text)
            } else {
                changedProfile = changedProfile.copyWithChanged(info: text)
            }
        }
        activeTextField = nil
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
















