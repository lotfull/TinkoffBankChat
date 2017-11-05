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
        nameTextField.delegate = self
        infoTextField.delegate = self
        loadProfile()
        updateUI(true)
        addNotifications()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCornerRadius()
    }
    
    func updateUI(_ firstTime: Bool? = false) {
        if firstTime == true {
            imageImageView.clipsToBounds = true
            saveProfileButton.layer.borderWidth = 1.0
            saveProfileButton.layer.cornerRadius = 12.0
        }
        imageImageView.image = changedProfile.image ?? #imageLiteral(resourceName: "placeholder-user")
        nameTextField.text = changedProfile.name ?? "Без Имени"
        infoTextField.text = changedProfile.info ?? "Без Описания"
    }
    
    private func setCornerRadius() {
        if cornerRadius == 0 {
            cornerRadius = (changeImageButton.bounds.size.width) / 2
        }
        changeImageButton.layer.cornerRadius = cornerRadius
        imageImageView.layer.cornerRadius = cornerRadius
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    private func enableButtonsIf(_ bool: Bool) {
        saveProfileButton.isEnabled = bool
        saveProfileButton.backgroundColor = bool ? .white : .black
    }

    // MARK: - @IBActions
    @objc private func dismissKeyboard() {
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
        
        nameTextField.endEditing(true)
        infoTextField.endEditing(true)
        activityIndicator.startAnimating()
        enableButtonsIf(false)
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
    
    // MARK: - @IBOutlets
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!

    // MARK: - Vars and Lets
    private var profile: Profile!
    private var changedProfile: Profile! {
        didSet {
            enableButtonsIf(changedProfile != profile)
            updateUI()
        }
    }
    private let managerGCD = GCDDataManager()
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return (url.appendingPathComponent("objectFile")?.path)!
    }
    var cornerRadius: CGFloat = 0.0
    //var activeTextField: UITextField?
    
    let isProfileImageLoaded = "isProfileImageLoaded"
    let isProfileNameLoaded = "isProfileNameLoaded"
    let isProfileInfoLoaded = "isProfileInfoLoaded"
    let profileNameKey = "profileName"
    let profileInfoKey = "profileInfo"
    let profileImageKey = "profileImage"
    let image = 0, name = 1, info = 2
    
    
}

// MARK: - Extensions
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField == nameTextField {
            changedProfile = changedProfile.copyWithChanged(name: textField.text)
        } else if textField == infoTextField {
            changedProfile = changedProfile.copyWithChanged(info: textField.text)
        }
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if textField == nameTextField {
                changedProfile = changedProfile.copyWithChanged(name: text)
            } else if textField == infoTextField {
                changedProfile = changedProfile.copyWithChanged(info: text)
            }
        }
    }
    
}

extension ProfileViewController {
    @objc private func keyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.contentTopConstraint?.constant = 0.0
            } else {
                if let keyboardHeignt = endFrame?.size.height {
                    self.contentTopConstraint?.constant = -keyboardHeignt/2.0
                }
            }
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
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

extension ProfileViewController: UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}















