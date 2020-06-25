//
//  ViewController.swift
//  MyReminders
//
//  Created by mac on 25/06/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!

    var models = [MyReminder]()
    var checkcount : Int = 0
    
    var filteredTableData = [MyReminder]()
    
      let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        initialise()
        
        navigationController?.navigationBar.prefersLargeTitles = true
               navigationItem.searchController = searchController
               navigationItem.hidesSearchBarWhenScrolling = true
               
               searchController.searchResultsUpdater = self
               searchController.dimsBackgroundDuringPresentation = false
               
               definesPresentationContext = true
               
        
        
    }
    
    func initialise() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        do{
            let result = try managedContext.fetch(fetchRequest)
            var i : Int = 0
            print(i)
            for data in result as! [NSManagedObject]{
               // managedContext.delete(data)
                  let title = (data.value(forKey: "title")as! String)
                  let body = (data.value(forKey: "desc")as! String)
                
                let new = MyReminder(title: title,identifier: body)
                self.models.append(new)
                i = i + 1
                print(i)
            }
        }catch{
            print("failed")
        }
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
                self.saveItem(title: title, desc: body)
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


extension ViewController: UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating {
  
    func filterContentForSearchText(searchText: String, scope: String = "All"){
         
         filteredTableData = models.filter({ (model)-> Bool in return (model.title as! String).lowercased().contains(searchText.lowercased()) })
         
        table.reloadData()
     }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    

 
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (searchController.isActive && searchController.searchBar.text != "") {
            return filteredTableData.count
        } else{
            return models.count
        }
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkcount = checkcount + 1
           
        let titl:String = models[indexPath.row].title
        let desc:String = models[indexPath.row].identifier
        let i:Int = indexPath.row
        let count:Int = models.count - 1
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
        
        
        if (searchController.isActive && searchController.searchBar.text != "") {
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
             cell.textLabel?.text = filteredTableData[indexPath.row].title
             
             cell.detailTextLabel?.text = filteredTableData[indexPath.row].identifier

             cell.textLabel?.font = UIFont(name: "Arial", size: 25)
             cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)

             return cell
         }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        
        cell.detailTextLabel?.text = models[indexPath.row].identifier

        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)

        return cell
        }
    }

    
    func saveItem(title: String, desc: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "List", in: managedContext)!
       let user = NSManagedObject(entity: userEntity, insertInto: managedContext
        )
        user.setValue(title, forKey: "title")
        user.setValue(desc, forKey: "desc")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("error")
        }
        
        
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
          do{
              let result = try managedContext.fetch(fetchRequest)
          
              for data in result as! [NSManagedObject]{
                  
                  print(data.value(forKey: "title")as! String)
                 
              }
          }catch{
              print("failed")
          }
        
        
    }
       
    
    
    
    
    
}


struct MyReminder {
    var title: String
    var identifier: String
}
