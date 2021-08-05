//
//  TodoListController.swift
//  CoreData_Todo
//
//  Created by Shreenivas on 05/08/21.
//

import UIKit
import CoreData

class TodoListController: UIViewController {

    
    @IBOutlet weak var segmentControl: UINavigationItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var vm = TodoListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func setupUi() {
        let nib = UINib(nibName: "TodoListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TodoListTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 36
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func onPressAdd(_ sender: Any) {
        self.performSegue(withIdentifier: "addUpdateSegue", sender: nil)
    }
    
    @IBAction func onSegmentValueChange(_ sender: Any) {
        if let sender = sender as? UISegmentedControl{
            vm.segmentIndex = sender.selectedSegmentIndex
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUpdateSegue",
           let destination = segue.destination as? AddUpdateTodoController,
           let updateTodo = sender as? Todo {
            destination.todoUpdateObj = updateTodo
        }
    }
    
}

//MARK:- UITableViewDataSource
extension TodoListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.reuseIdentifier, for: indexPath) as! TodoListTableViewCell
        cell.todo = vm.todoAt(index: indexPath.row)
        return cell
    }
    
}

//MARK:- UITableViewDelegate
extension TodoListController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteActionItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextualAction, view, boolValue) in
            
            self?.vm.deleteTaskAt(index: indexPath.row) { (_) in
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        let updateActionItem = UIContextualAction(style: .destructive, title: "Update") { [weak self] (contextualAction, view, boolValue) in
            let updateObj = self?.vm.todoAt(index: indexPath.row)
            self?.performSegue(withIdentifier: "addUpdateSegue", sender: updateObj)
        }
        
        updateActionItem.backgroundColor = .blue
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteActionItem, updateActionItem])

        return swipeActions
    }
}
