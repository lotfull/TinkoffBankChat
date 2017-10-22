//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol ProfileManager: class {
    func loadProfile(completion: @escaping (Profile?, Error?) -> Void)
    func saveProfile(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
}

class ProfileViewController: UIViewController {
    
    // MARK: Main funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
        updateUI(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cornerRadius == 0 {
            cornerRadius = (changeImageButton.bounds.size.width) / 2 // + 4
        }
        changeImageButton.layer.cornerRadius = cornerRadius
        imageImageView.layer.cornerRadius = cornerRadius
    }
    
    func updateUI(_ firstTime: Bool? = false) {
        if firstTime == true {
            imageImageView.clipsToBounds = true
            editProfileWithGCDButton.layer.borderWidth = 1.0
            editProfileWithGCDButton.layer.cornerRadius = 12.0
            editProfileWithOperationButton.layer.borderWidth = 1.0
            editProfileWithOperationButton.layer.cornerRadius = 12.0
        }
        imageImageView.image = changedProfile.image ?? #imageLiteral(resourceName: "placeholder-user")
        nameTextField.text = changedProfile.name
        infoTextField.text = changedProfile.info ?? ""
    }
    
    // MARK: - @IBActions
    
    @IBAction private func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    
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
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
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
    
    // MARK: - DataManagment
    func loadProfile() {
        activityIndicator.startAnimating()
        managerGCD.loadProfile { (profile, error) in
            self.activityIndicator.stopAnimating()
            if profile != nil {
                self.profile = profile
                self.changedProfile = profile
            }
            if error != nil {
                print("\(error!)")
            }
        }
        if profile == nil {
            self.profile = Profile.generate()
            self.changedProfile = Profile.generate()
            self.updateUI()
        }
        activityIndicator.stopAnimating()
    }
    
    private func saveProfile(with profileManager: ProfileManager) {
        activityIndicator.startAnimating()
        profileManager.saveProfile(changedProfile, completion: { [unowned self] saved, error  in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            if saved {
                let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
            if error != nil {
                print("\(error!)")
            }
        })
    }
    
    @IBAction func editProfileWithGCD(_ sender: Any?) {
        saveProfile(with: managerGCD)
    }
    @IBAction func editProfileWithOperation(_ sender: Any) {
        saveProfile(with: managerOperation)
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var editProfileWithGCDButton: UIButton!
    @IBOutlet weak var editProfileWithOperationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Vars and Lets
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
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return (url.appendingPathComponent("objectFile")?.path)!
    }
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

// MARK: - Extensions
extension ProfileViewController {
    @objc private func keyboardUp(notification: Notification) {
        
        //show = 1.0
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let verticalSpace = view.frame.height / 10
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + verticalSpace, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.frame.size.height -= keyboardFrame.height
        if self.activeTextField != nil {
            let activeFrame = activeTextField!.convert(activeTextField!.bounds, to: scrollView)
            let activeTextFieldBottomLeftPoint = CGPoint(x: activeFrame.minX, y: activeFrame.maxY)
            if !view.frame.contains(activeTextFieldBottomLeftPoint) {
                scrollView.scrollRectToVisible(activeFrame, animated: true)
            }
        }
    }
    
    @objc func keyboardDown(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        }
        changedProfile = changedProfile.copyWithChanged(image: image)
        dismiss(animated: true, completion: nil)
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
















