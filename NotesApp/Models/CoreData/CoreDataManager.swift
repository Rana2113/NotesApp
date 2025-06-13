//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Rana Mustafa on 02/06/2025.
//

import Foundation
import UIKit
import CoreData
class CoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    func storeData () {
        do {
            try self.context.save()
        } catch {
            print("error saveing note \(error)")
        }
    }
    
    
    
    func loadnote (with request :  NSFetchRequest<Note> = Note.fetchRequest()) -> [Note] {
        do {
            return try self.context.fetch(request)
        }
        catch{
            print("error loading data \(error)")
            return[]
        }
       
    }
    func deleteNote (note: Note){

        
        do {
          
            context.delete(note)
            
            try context.save()
            
        } catch {
            print("error Deleting note \(error)")
        }
    }
}
