//
//  NotesTableViewController.swift
//  MyNotes
//
//  Created by Lyons, Joseph John on 11/19/19.
//  Copyright © 2019 Lyons, Joseph John. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    
    // create a reference to a context
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    // create an array of ShoppingList entities
       var notes = [Notes] ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // fetch ShoppingLists from core data
    func loadNotes() {
        
        // create an instance of a fetchRequest so that
        // shoppingLists ca nbe fethed from core data
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        do {
            // use contex to execute a fetch request to fetch ShoppingLists
            // from core data, store the fetched ShoppingLists in our array
            notes = try context.fetch(request)
        } catch {
            print("Error fetching Notes from Core Data!")
        }
        
        // reload the fetched data in the Table View Controller
        tableView.reloadData()
    }

    // save shoppingList entity
    func saveNotes () {
        do {
            // use context to save ShoppingLists into Core Data
            try context.save()
        } catch {
            print("Error saving Notes to Core Data!")
        }
        
        // reload the data in the Table View Controller
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var titleTextField = UITextField()
        var typeTextField = UITextField()
        var dateTextField = UITextField()
        
        
        // create an Alert controllerr
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        
        // define an action that will occur when the Add List button is pushed
        let action = UIAlertAction(title: "Add Note", style: .default, handler: { (action) in
            
            // create an instance of a shoppingList entity
            let newNote = Notes(context: self.context)
            
            // get name, store, and date input by the user and store them in ShoppingList entity
            newNote.title = titleTextField.text!
            newNote.type = typeTextField.text!
            newNote.date = dateTextField.text!
            
            // add shoppingList entity into array
            self.notes.append(newNote)
            
            // save ShoppingLists into core data
            self.saveNotes()
            
        })
        
        // disable the action that will occur when the Add List button is pushrd
        action.isEnabled = false
        
        // define an action that will occur when the Cancel is pushed
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
            
            
        })
        
        // add actions into Alert controler
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // add the text fields into the alert controller
        alert.addTextField(configurationHandler: { (field) in
            titleTextField = field
            titleTextField.placeholder = "Enter Title"
            titleTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        // add the text fields into the alert controller
        alert.addTextField(configurationHandler: { (field) in
            typeTextField = field
            typeTextField.placeholder = "Enter Type"
            typeTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        // add the text fields into the alert controller
        alert.addTextField(configurationHandler: { (field) in
            dateTextField = field
            dateTextField.placeholder = "Enter Date"
            dateTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        
        // display the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange() {
        
        // get a reference to the Alert Controller
        let alertController = self.presentedViewController as! UIAlertController
        
        // get a reference to the action that allows the user to add a ShoppingList
        let action = alertController.actions[0]
        
        // get references to the text in the Text Fields
        if let title = alertController.textFields![0].text, let
            type = alertController.textFields![1].text, let
            date = alertController.textFields![2].text {
            
            //trim whitespaces from the text
            let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
            let trimmedType = type.trimmingCharacters(in: .whitespaces)
            let trimmedDate = date.trimmingCharacters(in: .whitespaces)
            
            // check if the trimmed text isnt empty and if it isnt, enable the action
            // that allows the user to add a ShoppingList
            if(!trimmedTitle.isEmpty && !trimmedType.isEmpty && !trimmedDate.isEmpty) {
                action.isEnabled = true
            }
        }
            
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)

        // Configure the cell...
        let Notes = notes[indexPath.row]
        cell.textLabel?.text = Notes.title!
        cell.detailTextLabel?.text = Notes.type! + " " + Notes.date!
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
