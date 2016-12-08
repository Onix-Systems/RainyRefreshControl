//
//  ViewController.swift
//  RainyRefresh
//
//  Created by Anton Dolzhenko on 14.11.16.
//  Copyright © 2016 Onix Systems. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    fileprivate var items = Array(1...10).map{ "\($0)"}
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var refreshHeaderView: RainyRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        if refreshHeaderView == nil {
            let view = RainyRefreshControl(frame: CGRect(x: 0, y: 0 - tableView.bounds.size.height, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            view.delegate = self
            tableView.addSubview(view)
            refreshHeaderView = view
        }
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
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

// MARK: - RainyRefreshControlDelegate

extension ViewController: RainyRefreshControlDelegate {
    func pullToRefreshDidTrigger(_ view: RainyRefreshControl) {
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
        })
    }

}

