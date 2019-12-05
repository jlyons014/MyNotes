//
//  NotesTableViewController.swift
//  MyNotes
//
//  Created by Lyons, Joseph John on 11/19/19.
//  Copyright © 2019 Lyons, Joseph John. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class NotesTableViewController: UITableViewController {
    
    // create a reference to a context
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    // create an array of ShoppingList entities
       var notes = [Notes] ()
    
    // create a variable that will contain the row of the selected shopping list
    var selectedNote: Notes?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

         // call load shoppinh list items method
               loadNotes()
               
               // make row height larger
               self.tableView.rowHeight = 84.0
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
    
    func deleteNote(item: Notes){
        context.delete(item)
        do{
            try context.save()
        } catch {
            print("Error deleting Note from core data!")
        }
        loadNotes()
    }
    
    func allNotesDeletedNotification() {
        
        var done = true
        
        for item in notes {
          
            if notes[0] == nil{
                // set done to false
                done = false
            }
        }
        
        // check if done is true
        if done == true {
            
            // create content objejct that controls the content and sound of the notification
            let content = UNMutableNotificationContent()
            content.title = "MyNotes"
            content.body = "All Notes Deleted!"
            content.sound = UNNotificationSound.default
            
            // create trigger object that defines when the notification will be sent and if it
            // should be sent repeatidly
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            // create request object that is responsible for creating the notification
            let request = UNNotificationRequest(identifier: "notesIdentifier", content: content, trigger: trigger)
            
            // post the notification
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var titleTextField = UITextField()
        var typeTextField = UITextField()
        
        
        // create an Alert controllerr
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        
        // define an action that will occur when the Add List button is pushed
        let action = UIAlertAction(title: "Add Note", style: .default, handler: { (action) in
            
            // create an instance of a shoppingList entity
            let newNote = Notes(context: self.context)
            
            // get name, store, and date input by the user and store them in ShoppingList entity
            newNote.title = titleTextField.text!
            newNote.type = "Type: " + typeTextField.text!
            
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
            type = alertController.textFields![1].text {
            
            //trim whitespaces from the text
            let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
            let trimmedType = type.trimmingCharacters(in: .whitespaces)
            
            // check if the trimmed text isnt empty and if it isnt, enable the action
            // that allows the user to add a ShoppingList
            if(!trimmedTitle.isEmpty && !trimmedType.isEmpty) {
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
        cell.detailTextLabel?.text = Notes.type!
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
          let item = notes[indexPath.row]
          deleteNote(item: item)
        }
        }

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
