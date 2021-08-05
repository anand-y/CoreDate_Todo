//
//  TodoListVM.swift
//  CoreData_Todo
//
//  Created by Shreenivas on 05/08/21.
//

import Foundation
import CoreData

class TodoListVM {
    
    var todo: [Todo] = []
    var todayTodo: [Todo] = []
    var tommorowTodo: [Todo] = []
    var upcomingTodo: [Todo] = []
    
    var segmentIndex = 0
    
    var count: Int {
        switch segmentIndex {
            case 0:
                return todayTodo.count
            case 1:
                return tommorowTodo.count
            case 2:
                return upcomingTodo.count
            default:
                return 0
        }
    }
    
    init() {
        self.refreshData()
    }
    
    func todoAt(index: Int) -> Todo? {
        switch segmentIndex {
            case 0:
                return todayTodo[index]
            case 1:
                return tommorowTodo[index]
            case 2:
                return upcomingTodo[index]
            default:
                return nil
        }
    }
    
    func refreshData() {
        self.todo = CoredataManager.shared.getAllTodoRecord()
        setupTodoByTime()
    }
    
    func setupTodoByTime() {
        
        self.todayTodo = self.todo.filter({ todoItem in
            if let date = todoItem.due_on{
                return Calendar.current.isDateInToday(date)
            } else {
                return false
            }
        })
        
        
        self.tommorowTodo = self.todo.filter({ todoItem in
            if let date = todoItem.due_on{
                return Calendar.current.isDateInTomorrow(date)
            } else {
                return false
            }
        })
        
        self.upcomingTodo = self.todo.filter({ todoItem in
            if let date = todoItem.due_on{
                
                let calendar = Calendar.current
                let startOfNow = calendar.startOfDay(for: Date())
                let startOfTimeStamp = calendar.startOfDay(for: date)
                
                let dateDifferenceComponent = Calendar.current.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
                
                return ((dateDifferenceComponent.day ?? 0) > 1) ? true : false
                
            } else {
                return false
            }
        })

    }
    
    func deleteTaskAt(index: Int, completeion: @escaping (Bool) -> Void) {
        var todoDeleteObj = Todo()
        switch segmentIndex {
            case 0:
                todoDeleteObj = todayTodo[index]
            case 1:
                todoDeleteObj = tommorowTodo[index]
            case 2:
                todoDeleteObj = upcomingTodo[index]
            default:
                completeion(false)
        }
        CoredataManager.shared.deleteRequest(todo: todoDeleteObj, completion: completeion)
        refreshData()
    }
}
