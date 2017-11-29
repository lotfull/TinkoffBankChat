//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit



class ProfileViewController: UIViewController, ProfileDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Vars and Lets
    private var profile: Profile!
    private var changedProfile: Profile! {
        didSet {
            enableButtonsIf(changedProfile != profile)
            updateUI(firstTime: false)
        }
    }
//    private let managerGCD = GCDDataManager()
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return (url.appendingPathComponent("objectFile")?.path)!
    }
    var cornerRadius: CGFloat = 0.0
    
    let isProfileImageLoaded = "isProfileImageLoaded"
    let isProfileNameLoaded = "isProfileNameLoaded"
    let isProfileInfoLoaded = "isProfileInfoLoaded"
    let profileNameKey = "profileName"
    let profileInfoKey = "profileInfo"
    let profileImageKey = "profileImage"
    let image = 0, name = 1, info = 2
    
    // MARK: - @IBOutlets
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    
    // MARK: - ProfileDelegate methods
    func updateUI(firstTime: Bool) {
        if firstTime {
            imageImageView.clipsToBounds = true
            saveProfileButton.layer.borderWidth = 1.0
            saveProfileButton.layer.cornerRadius = 12.0
        }
        imageImageView.image = changedProfile.image ?? #imageLiteral(resourceName: "placeholder-user")
        nameTextField.text = changedProfile.name ?? "Без Имени"
        infoTextField.text = changedProfile.info ?? "Без Описания"
    }
    
    var model: IProfileModel!
    static func initWith(model: IProfileModel) -> ProfileViewController {
        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.model = model
        return profileVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Main funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        infoTextField.delegate = self
        loadProfile()
        updateUI(firstTime: true)
        enableKeyboardActions()
    }
    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePC = UIImagePickerController()
        imagePC.delegate = self
        imagePC.allowsEditing = false
        return imagePC
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        setCornerRadius()
    }
    
    // MARK: - UI
    private func setCornerRadius() {
        if cornerRadius == 0 {
            cornerRadius = (changeImageButton.bounds.size.width) / 2
        }
        changeImageButton.layer.cornerRadius = cornerRadius
        imageImageView.layer.cornerRadius = cornerRadius
    }
    private func enableKeyboardActions() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    private func enableButtonsIf(_ bool: Bool) {
//        saveProfileButton.isEnabled = bool
//        saveProfileButton.backgroundColor = bool ? .white : .black
        saveProfileButton.isHidden = !bool
    }
    private func UIinSaveMode(_ yes: Bool) {
        if yes {
            self.nameTextField.endEditing(true)
            self.infoTextField.endEditing(true)
            self.activityIndicator.startAnimating()
            enableButtonsIf(false)
        } else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
//            self.enableButtonsIf(true)
        }
    }
    
    // MARK: - @IBActions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeImageAction(_ sender: Any) {
        self.present(chooseActionSheet, animated: true, completion: nil)
    }
    
    // MARK: - DataManagment
    func loadProfile() {
        activityIndicator.startAnimating()
        model.loadProfile { profile, error in
            self.profile = profile
            self.changedProfile = profile
            print(error != nil ? "\(error!)" : "load profile success")
        }
        activityIndicator.stopAnimating()
    }
    
    @IBAction func saveProfileButtonPressed(_ sender: Any?) {
        UIinSaveMode(true)
        model.saveProfile(changedProfile) { saved, error in
            DispatchQueue.main.async {
                self.UIinSaveMode(false)
                self.present(saved ? self.successAlert : self.failAlert, animated: true, completion: nil)
            }
            print(error != nil ? "\(error!)" : "save profile success")
        }
    }
    
    // MARK: - Alerts
    private var chooseActionSheet: UIAlertController {
        let chooseActionSheet = UIAlertController(title: "Library or Camera?", message: "Choose a image from Library or take new image", preferredStyle: .actionSheet)
        chooseActionSheet.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                print("Image Library not available")
            }
        }))
        chooseActionSheet.addAction(UIAlertAction(title: "Сфотографировать", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        chooseActionSheet.addAction(UIAlertAction(title: "Из интернета", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "ProfileImagePickerViewController", sender: nil)
        }))
        chooseActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return chooseActionSheet
    }
    
    private var successAlert: UIAlertController {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    private var failAlert: UIAlertController {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.saveProfileButtonPressed(nil)
        }))
        return alert
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileImagePickerViewController" {
            guard let containerViewController = segue.destination as? UINavigationController,
                let profileImagePickerViewController = containerViewController.topViewController as? ProfileImagePickerViewController else {
                    assertionFailure("Unknown segue destination")
                    return
            }
            RootAssembly.profileImagePickerAssembly.assembly(profileImagePickerViewController)
            profileImagePickerViewController.onSelectProfileImage = { [weak self] selectedImage in
                self?.updateUserProfile(with: selectedImage)
            }
        } else if segue.identifier == "unwindSegueToConversationsList" {
            return
        }
    }
    
    private func updateUserProfile(with image: UIImage?) {
        imageImageView.image = image
        changedProfile = profile?.copyWithChanged(image: image)
    }
    
// MARK: - UITextFieldDelegate
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
  
// MARK: - keyboardNotification
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
                    self.contentTopConstraint?.constant = -keyboardHeignt/1.5
                }
            }
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
// MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        }
        changedProfile = changedProfile.copyWithChanged(image: image)
        dismiss(animated: true, completion: nil)
    }
    
// MARK: - UINavigationControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}















