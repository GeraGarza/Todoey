//
//  ViewController.swift
//  Todoey
//
//  Created by Gera Garza on 6/24/18.
//  Copyright © 2018 Gera Garza. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
     let dataFilePathToo = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("Products.plist")
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        print("GEEERR \(dataFilePathToo!)")
    }
    
    //MARK: - TV data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item =  itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //value = condition ? valueT : valueF
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK:- Add new item
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("\(error)")
        }
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePathToo!)
        }catch{
            print("\(error)")
        }
        self.tableView.reloadData()
        
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
        }
        
    }
    
    
    
    
    
}


