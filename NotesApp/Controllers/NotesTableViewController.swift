//
//  NotesTableViewController.swift
//  NotesApp
//
//  Created by Rana Mustafa on 30/05/2025.
//
import UIKit
import CoreData
class NotesTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notes = [Note]()
    var pinnedNotes = [Note]()
    var unpinnedNotes = [Note]()
    let coreData = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register((UINib(nibName: "NotesTableViewCell" , bundle: nil)), forCellReuseIdentifier: "NoteCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notes = coreData.loadnote()
        pinnedNotes = notes.filter { $0.isPinned }
        unpinnedNotes = notes.filter { !$0.isPinned }
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return pinnedNotes.isEmpty ? 1 : 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        if pinnedNotes.isEmpty {
            return "Notes"
        } else {
            if section == 0 {
                return "Pinned"
            } else {
                return unpinnedNotes.isEmpty ? nil : "Notes"
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pinnedNotes.isEmpty {
            return unpinnedNotes.count
        } else {
            return section == 0 ? pinnedNotes.count : unpinnedNotes.count
        }
    }
    
 
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NotesTableViewCell
         let note = noteForIndexPath(indexPath)
         cell.titleNote.text = note.title
         if let content = note.content, !content.isEmpty {
             cell.contentNote.text = content  } else {
             cell.contentNote.text = "No additional text"
         }
         
         if let Date = note.createdAt {
             let calendar = Calendar.current
             let formatter = DateFormatter()
             if calendar.isDateInToday(Date)
             {
                 formatter.timeStyle = .short
                 formatter.dateStyle = .none
             } else {
                 formatter.timeStyle = .none
                 formatter.dateStyle = .medium
             }
             cell.createAt.text = formatter.string(from: Date)
         }

     return cell
     }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (UIContextualAction, UIView, completionHandler) in
            let note = self.noteForIndexPath(indexPath)
            self.coreData.deleteNote(note: note)
            self.reloadPinnedAndUnpinned()
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
       
        return swipeConfiguration
        
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (UIContextualAction, UIView, completionHandler) in
            let note = self.noteForIndexPath(indexPath)
            let defaultText = "Just shared note: \(note.title ?? "Untitled")"
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
            
        }
        let pinAction = UIContextualAction(style: .normal, title: "Pin") { (UIcontextualAction , UIview , completionHandler) in
            let note = self.noteForIndexPath(indexPath)
            note.isPinned.toggle()
            self.coreData.storeData()
            self.reloadPinnedAndUnpinned()
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
            completionHandler(true)
            
        }
        let note = self.noteForIndexPath(indexPath)
        pinAction.image = UIImage(systemName: note.isPinned ? "pin.slash.fill" : "pin.fill")
        pinAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [shareAction , pinAction])
       
        return swipeConfiguration
    }
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addNewNote", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destenationVC = segue.destination as! NoteViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destenationVC.selectedNote = noteForIndexPath(indexpath)
        }
    }

    @IBAction func addNote(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewNote", sender: self)

    }
    
    
}

     //MARK: - Search Bar Methods
extension NotesTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "content CONTAINS[cd] %@", searchBar.text!) , NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        ])
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        notes = coreData.loadnote(with: request)
        pinnedNotes = self.notes.filter { $0.isPinned }
        unpinnedNotes = self.notes.filter { !$0.isPinned }
        self.tableView.reloadData()
        if self.notes.isEmpty {
            searchBar.resignFirstResponder()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty == true {
            reloadPinnedAndUnpinned()
            self.tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    
    func noteForIndexPath(_ indexPath: IndexPath) -> Note {
        if pinnedNotes.isEmpty {
            return unpinnedNotes[indexPath.row]
        } else {
            return indexPath.section == 0 ? pinnedNotes[indexPath.row] : unpinnedNotes[indexPath.row]
        }
    }
    
    func reloadPinnedAndUnpinned() {
        notes = coreData.loadnote()
        pinnedNotes = self.notes.filter { $0.isPinned }
        unpinnedNotes = self.notes.filter { !$0.isPinned }
    }
}
