//
//  ChatsListViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 05.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import CoreData

class ChatsListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManager = DataManager()
    private lazy var dataSource = ChatsListDataSource(dataManager)
    
    let chatsTableViewCellName = "ChatCell"
    let chatsTableViewCellID = "ChatCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: chatsTableViewCellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: chatsTableViewCellID)
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
        if let chatVC = segue.destination as? ChatViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedCell = dataSource.tableView(tableView, cellForRowAt: selectedIndexPath) as? ChatCell {
            let selectedChat  = dataSource.chat(for: selectedIndexPath)
            chatVC.chat = selectedChat
            chatVC.dataManager = dataManager
            chatVC.navigationItem.title = selectedCell.name
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
}
