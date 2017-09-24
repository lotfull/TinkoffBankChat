//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        logFunctionName()
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        logFunctionName()
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        logFunctionName()
        super.viewDidAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        logFunctionName()
        super.viewWillLayoutSubviews()
    }
    override func viewDidLayoutSubviews() {
        logFunctionName()
        super.viewDidLayoutSubviews()
    }
    override func viewWillDisappear(_ animated: Bool) {
        logFunctionName()
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        logFunctionName()
        super.viewDidDisappear(animated)
    }
    
    func logFunctionName(method: String = #function) {
        print("Completed ProfileVC.\(lastMethod)\nStarted ProfileVC.\(method)")
        lastMethod = method
    }
    
    var lastMethod: String = "Opening VC"

}

