//
//  ViewController.swift
//  TextTools
//
//  Created by Felipe Díaz on 01/11/16.
//  Copyright © 2016 Felipe Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames
        {
            let names = UIFont.fontNames(forFamilyName: familyName)
            for name in names {
                dataSource.append((familyName, name))
            }
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell")
        
        let value = dataSource[indexPath.row]
        cell?.textLabel?.text = value.0
        cell?.textLabel?.font = UIFont(name: value.1, size: 16)
        
        cell?.detailTextLabel?.text = value.1
        
        return cell!
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = dataSource[indexPath.row].1
    }
}

