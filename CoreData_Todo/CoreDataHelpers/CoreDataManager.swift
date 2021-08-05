//
//  CoreDataManager.swift
//  CoreData_Todo
//
//  Created by Shreenivas on 05/08/21.
//

import Foundation
import CoreData

final class CoredataManager {
    
    static let shared = CoredataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    /**
        Core data stack Setup
     */
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreData_Todo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
}
// MARK: - Todo CoreData Funtion
/**
    Todo specific setup
 */

extension CoredataManager {
    
    ///Add record
    func saveTodo(name: String, descriptionTxt: String?, dueOn: Date, completion: @escaping (Bool) -> Void) {
        
        let todo = Todo(context: persistentContainer.viewContext)
        todo.name = name
        todo.descrip = descriptionTxt
        todo.due_on = dueOn
        todo.added_on = Date()
        todo.updated_on = Date()
        todo.id = UUID()
        saveContext()
        completion(true)
    }
    
    ///Fetch  All Record
    func getAllTodoRecord() -> [Todo] {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        var todo: [Todo] = []
        
        do {
            todo = try persistentContainer.viewContext.fetch(request)
        } catch let err {
            print("Core data Error while fetching ",err.localizedDescription)
        }
        
        return todo
    }
    
    ///Update Record
    func updateRequest(todo t: Todo, title: String?, descriptionStr: String?, dueDate: Date?, completion: @escaping (Bool) -> Void) {
        
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", t.id!.uuidString)
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if result.count > 0 {
                
                let todo = result.first!
                if let title = title {
                    todo.name = title
                }
                if let date = dueDate {
                    todo.due_on = date
                }
                if let descStr = descriptionStr {
                    todo.descrip = descStr
                }
                todo.updated_on = Date()
                
                saveContext()
                
                completion(true)
            }
        } catch let err {
            print("Core data Error while fetching ",err.localizedDescription)
        }
    }
    
    ///delete record
    func deleteRequest(todo t: Todo, completion: @escaping (Bool) -> Void) {
        
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", t.id!.uuidString)
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            if result.count > 0 {
                let todo = result.first!
                persistentContainer.viewContext.delete(todo)
                saveContext()
                completion(true)
            }
        } catch let err {
            print("Core data Error while fetching ",err.localizedDescription)
        }
    }
    
}
