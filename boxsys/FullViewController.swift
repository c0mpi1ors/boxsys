//
//  FullViewController.swift
//  boxsys
//
//  Migrated to Swift from Objective-C
//

import UIKit

class FullViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JuBoxSysDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    // MARK: - JuBoxSysDelegate

    func getContainer() -> UIView {
        return self.view
    }

    func onBoxSysEvent(sender: Any, args: [String: Any]?) {
        // Handle box system events
    }
}
