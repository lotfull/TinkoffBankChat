//
//  ChatsListViewController_.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 30.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChatsListViewController_: UIViewController, IChatsListModelDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var model: IChatsListModel!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
//
//    convenience init(model: IChatsListModel) {
//        self.init()
//        self.model = model
//    }
//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //configureTableView()

    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
    }
    
    private var dataSource: [[Chat]] = [[], []]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = dataSource[indexPath.section][indexPath.row]
        let identifier = ChatCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatCell
        cell.configure(with: chat)
        return cell
    }
    
    func setup(dataSource: [[Chat]]) {
        self.dataSource = dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


