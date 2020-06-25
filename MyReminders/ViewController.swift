//
//  ViewController.swift
//  MyReminders
//
//  Created by mac on 25/06/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!

    var models = [MyReminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
    }

    @IBAction func didTapAdd() {
        // show add vc
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else {
            return
        }

        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title,identifier: body)
                self.models.append(new)
                self.table.reloadData()

                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
            }
        }
        navigationController?.pushViewController(vc, animated: true)

    }




}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].identifier

        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)
        return cell
    }

}


struct MyReminder {
    let title: String
    let identifier: String
}
