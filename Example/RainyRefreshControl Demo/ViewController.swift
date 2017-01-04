//
//  ViewController.swift
//  RainyRefreshControl Demo
//
//  Created by Anton Dolzhenko on 04.01.17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import UIKit
import RainyRefreshControl

class ViewController: UIViewController {
    
    fileprivate var items = Array(1...10).map{ "\($0)"}
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let refresh = RainyRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        refresh.addTarget(self, action: #selector(ViewController.doRefresh), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    func doRefresh(){
        let popTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.refresh.endRefreshing()
        }
    }

}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.config()
        return cell
    }
    
}

