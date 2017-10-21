//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManager = DataManager()
    private lazy var dataSource = ConversationsListDataSource(dataManager)
    
    let conversationsTableViewCellName = "ConversationCell"
    let conversationsTableViewCellID = "ConversationCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: conversationsTableViewCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: conversationsTableViewCellID)
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ChatPressed", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationVC = segue.destination as? ConversationViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedCell = dataSource.tableView(tableView, cellForRowAt: selectedIndexPath) as? ConversationCell {
            let selectedChat  = dataSource.chat(for: selectedIndexPath)
            conversationVC.chat = selectedChat
            conversationVC.dataManager = dataManager
            conversationVC.navigationItem.title = selectedCell.name
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
}
