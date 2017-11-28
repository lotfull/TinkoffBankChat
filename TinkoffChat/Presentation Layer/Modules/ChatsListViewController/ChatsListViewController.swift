//
//  ChatsListViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ChatsListViewController: UIViewController {
    
//    var coreDataStack: CoreDataStack!
//
//    // MARK: - ChatsListDelegate
//    func updateUI(with chats: [[Chat]]) {
//        DispatchQueue.main.async {
//            self.chats = chats
//            self.updateChatsList()
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var model: IChatsListModel!
    
    var chats = [[Chat]]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func initWith(model: IChatsListModel) -> ChatsListViewController {
        let chatsListVC = UIStoryboard(name: "ChatsList", bundle: nil).instantiateViewController(withIdentifier: "ChatsListViewController") as! ChatsListViewController
        chatsListVC.model = model
        return chatsListVC
    }
    
    let chatsTableViewCellName = "ChatCell"
    let chatsTableViewCellID = "ChatCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: chatsTableViewCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: chatsTableViewCellID)
        model.setup(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedChatID = model.chatID(for: indexPath)
        let chatVC = ChatAssembly().chatViewController(withChatID: selectedChatID)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func presentProfile(_ sender: Any) {
        let profileVC = ProfileAssembly().profileViewController()
        let navigationController = UINavigationController.init(rootViewController: profileVC)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func updateChatsList() {
        tableView.reloadData()
    }
    
    private let sectionName = ["Online", "History"]
}

