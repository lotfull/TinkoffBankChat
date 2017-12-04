//
//  ChatVC.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController, UITextViewDelegate, IChatModelDelegate {
    
    var model: IChatModel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: SendButton!
    @IBOutlet weak var bottomContentConstraint: NSLayoutConstraint!
    
    private var animatableTitleLabel: AnimatableTitleLabel!

    @IBAction func sendButtonPressed(_ sender: Any) {
        guard inputTextView.text != "" else { return }
        inputTextView.text = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        model.sendMessage(text: inputTextView.text) { (success, error) in
            guard success == true else {
                assertionFailure(error?.localizedDescription ?? "ooops");
                return
            }
            self.tableView.reloadData()
        }
        inputTextView.text = ""
    }

    static func initWith(model: IChatModel) -> ChatViewController {
        let chatVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.model = model
        chatVC.animatableTitleLabel = AnimatableTitleLabel(isOnline: model.isOnline)
        return chatVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.setup(tableView)
        configureTitle(with: model.name)
        configureInputView()
        addKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.markChatAsRead()
        animateTitleLabel(model.isOnline)
        sendButton.isEnabled = model.isOnline
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToBottom()
        tableView.reloadData()
    }
    
    private func configureTitle(with userName: String) {
        animatableTitleLabel.text = userName
        navigationItem.titleView = animatableTitleLabel
    }
    
    private func configureInputView() {
        inputView?.addLine(to: .top, color: .blue)
        inputTextView?.layer.borderWidth = 0.5
        inputTextView?.layer.borderColor = UIColor.blue.cgColor
    }
    
    private func animateTitleLabel(_ online: Bool) {
        animatableTitleLabel.isOnline = online
    }
    
    func userBecameOnline(online: Bool) {
        sendButton.isEnabled = online
        animateTitleLabel(online)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func scrollToBottom() {
        DispatchQueue.main.async {
            let sections = self.tableView.numberOfSections
            let rows = self.tableView.numberOfRows(inSection: sections - 1)
            if rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: (sections - 1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.text != ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let newText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            newText.replaceCharacters(in: range, with: text)
            return newText.length < 140
        }
        return true
    }
    
    // MARK: - KeyBoard notifications
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    @objc private func keyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.height {
                self.bottomContentConstraint?.constant = 0.0
            } else {
                if let keyboardHeignt = endFrame?.size.height {
                    self.bottomContentConstraint?.constant = keyboardHeignt
                }
            }
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: {_ in self.scrollToBottom() })
        }
    }
}



