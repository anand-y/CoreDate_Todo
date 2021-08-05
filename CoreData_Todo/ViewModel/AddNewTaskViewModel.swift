//
//  AddNewTaskViewModel.swift
//  CoreData_Todo
//
//  Created by Shreenivas on 05/08/21.
//

import Foundation

class AddNewTaskViewModel {
    var nameStr: String
    var descriptionStr: String?
    var dueDate: Date
    
    init(name: String, descriptionStr:String?, dueDate: Date) {
        nameStr = name
        self.descriptionStr = descriptionStr
        self.dueDate = dueDate
    }
    
    convenience init(todoObj: Todo) {
        self.init(name: todoObj.name!, descriptionStr: todoObj.descrip, dueDate: todoObj.due_on!)
    }
    
    func saveTask(completion: @escaping (Bool) -> Void) {
        CoredataManager.shared.saveTodo(name: nameStr, descriptionTxt: descriptionStr, dueOn: dueDate, completion: completion)
    }
    
    func updateTask(todoObj: Todo, title: String?, descriptionStr: String?, dueDate: Date?, completion: @escaping (Bool) -> Void) {
        CoredataManager.shared.updateRequest(todo: todoObj, title: title, descriptionStr: descriptionStr, dueDate: dueDate, completion: completion)
    }
}
