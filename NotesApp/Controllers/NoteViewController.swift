//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Rana Mustafa on 02/06/2025.

import UIKit

class NoteViewController: UIViewController , UITextViewDelegate {
    let coreData = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notes = [Note]()
    var selectedNote : Note?
   

    @IBOutlet weak var noteTextField: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextField.delegate = self

        if let editNote = selectedNote, let titleNote = editNote.title, let contentNote = editNote.content {
            let fullText = titleNote + "\n" + contentNote
            let attributedString = NSMutableAttributedString(string: fullText)
            let titleRange = NSRange(location: 0, length: titleNote.count)
            let contentRange = NSRange(location: titleNote.count + 1, length: contentNote.count)

            attributedString.addAttributes([
                .font: UIFont.boldSystemFont(ofSize: 26),
                .foregroundColor: UIColor.label
            ], range: titleRange)
            
            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.label
            ], range: contentRange)

            noteTextField.textColor = .label
            noteTextField.attributedText = attributedString
        } else {
            noteTextField.typingAttributes = [
                .font: UIFont.boldSystemFont(ofSize: 26),
                .foregroundColor: UIColor.label
            ]
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextField.becomeFirstResponder()

    }
    

    
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        if let text = noteTextField.text , !text.isEmpty {
            let lines = text.components(separatedBy: .newlines)
            let title = lines.first ?? ""
            let content = lines.dropFirst().joined(separator: "\n")
            //Edit selected Note
            if let editNote = selectedNote {
                editNote.title = title
                editNote.content = content
                editNote.createdAt = Date()
            } else
            
            //Save new note
            {
                let newNote = Note (context : self.context)
                newNote.content = content
                newNote.title = title
                newNote.createdAt = Date()
                newNote.isPinned = false
                self.notes.append(newNote)
            }
            coreData.storeData()
            noteTextField.resignFirstResponder()
            sender.isEnabled = false
            navigationController?.popViewController(animated: true)
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let currentAttributes = textView.typingAttributes
            var newAttributes = currentAttributes
            newAttributes[.font] = UIFont.systemFont(ofSize: 20)
            textView.typingAttributes = newAttributes
        }
        return true
    }
    
}
