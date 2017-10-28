//
//  ChatVC.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.isEnabled = true//false
        }
    }
    @IBOutlet weak var bottomContentConstraint: NSLayoutConstraint!
    
    var chat: Chat!
    var connectionManager: ConnectionManager! {
        didSet {
            connectionManager.delegate = self
        }
    }
    private lazy var dataSource = ChatDataSource(chat: chat)
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        inputTextView.text = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        connectionManager.sendMessage(text: inputTextView.text, to: chat)
        inputTextView.text = ""
        sendButton.isEnabled = true//false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = chat.name
        tableView.dataSource = dataSource
        addNotifications()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToBottom()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    private func enableSendButton(_ trueOrFalse: Bool) {
        sendButton.isEnabled = true///trueOrFalse && !inputTextView.text.isEmpty
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let ifOnlineAndNotEmpty = chat.isOnline && textView.text != ""
        enableSendButton(ifOnlineAndNotEmpty)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let newText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            newText.replaceCharacters(in: range, with: text)
            return newText.length < 140
        }
        return true
    }
}

extension ChatViewController: ConnectionManagerDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollToBottom()
            self.enableSendButton(self.chat.isOnline)
        }
    }
}

extension ChatViewController {
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



