//
//  ChatVC.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 07.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController, UITableViewDataSource, UITextViewDelegate, ChatMessagesDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.isEnabled = true//false
        }
    }
    
    @IBOutlet weak var bottomContentConstraint: NSLayoutConstraint!
    
    var chat: Chat!
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard inputTextView.text != "" else { return }
        inputTextView.text = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        model.sendMessage(string: inputTextView.text, to: chat) { (success, error) in
            guard success == true else { print(error?.localizedDescription ?? "ooops"); return }
            self.tableView.reloadData()
        }//e(string: inputTextView.text, to: chat, completionHandler: nil)
        inputTextView.text = ""
        sendButton.isEnabled = true//false
    }
    
    var model: IChatModel!
    
    static func initWith(model: IChatModel) -> ChatViewController {
        let chatVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.model = model
        return chatVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = chat.name
        tableView.dataSource = self
//        tableView.delegate = self
        addNotifications()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToBottom()
        model.newMessagesFetch()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        let identifier = message.type == .inbox ? CellIdentifier.inboxCellID : CellIdentifier.outboxCellID
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.selectionStyle = .none
        if let messageCell = cell as? MessageCellConfiguration {
            messageCell.messageText = message.text
        }
        return cell
    }
    
    //MARK: - UITextViewDelegate
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
    
    // MARK: - ChatMessagesDelegate
    func updateUI(with chat: Chat) {
        DispatchQueue.main.async {
            // Тут уже вроде chat изменился. Выполним проверку
            print("*** \n self.chat.messages.last?: \(self.chat.messages.last?.text ?? "EMPTY") \n\n NEWchat.messages.last?: \(chat.messages.last?.text ?? "EMPTY") \n")
            self.tableView.reloadData()
            self.scrollToBottom()
            self.enableSendButton(self.chat.isOnline)
        }
    }
    
    // MARK: - KeyBoard notifications
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
    
    // MARK: - DataSource
    struct CellIdentifier {
        static let inboxCellID = "InboxCell"
        static let outboxCellID = "OutboxCell"
    }
    
    let inboxCell = "InboxCell"
    let outboxCell = "OutboxCell"
}



