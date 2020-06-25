//
//  ViewController.swift
//  MyReminders
//
//  Created by mac on 25/06/20.
//  Copyright © 2020 mac. All rights reserved.
//

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

        vc.title = "New Todo Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title,identifier: body)
                self.models.append(new)
                self.table.reloadData()


            }
        }
        navigationController?.pushViewController(vc, animated: true)

    }




}

//extension ViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//    }
//
//}


extension ViewController: UITableViewDataSource,UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        var titl:String = models[indexPath.row].title
        var desc:String = models[indexPath.row].identifier
        var i:Int = indexPath.row
        var count:Int = models.count - 1
        if(count>1 && i<count){
        for index in i...count-1{
            models[index].title = models[index+1].title
            models[index].identifier = models[index+1].identifier
        }
                 models[count].title = titl
                 models[count].identifier = desc
        }
        tableView.reloadData()
     }

     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
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
    var title: String
    var identifier: String
}
