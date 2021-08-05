//
//  AddUpdateTodoController.swift
//  CoreData_Todo
//
//  Created by Shreenivas on 05/08/21.
//

import UIKit
import CoreData

class AddUpdateTodoController: UIViewController {

    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dueDateTextField: UITextField!
    
    let descriptionPlaceHolder: String = "Enter description..."
    
    var todoUpdateObj: Todo? = nil
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
    }
    
    func setupUI() {
        
        descriptionTextView.delegate = self
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        descriptionTextView.text = descriptionPlaceHolder
        
        if let todoObj = todoUpdateObj {
            title = "Update"
            saveBtn.setTitle("Update", for: .normal)
            titleLabel.text = todoObj.name
            
            if let desc = todoObj.descrip,
               desc != descriptionPlaceHolder{
                descriptionTextView.text = desc
            }
            if let date = todoObj.due_on {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormatter.DateFormatString.dateStr
                dueDateTextField.text = dateFormatter.string(from: date)
            }
            
        } else {
            title = "Add"
            saveBtn.setTitle("Add", for: .normal)
        }
    }
    
    func setupDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let calendar = Calendar.current
        //check if add / update
        if let todoObj = todoUpdateObj {
            datePicker.date = todoObj.due_on ?? Date()
        } else {
            datePicker.minimumDate = Date()
        }
        datePicker.maximumDate = calendar.date(byAdding: .day, value: 30, to: Date())
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        // add toolbar to textField
        dueDateTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        dueDateTextField.inputView = datePicker
        
    }
    @objc  func donedatePicker(){
        ///For date formate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.DateFormatString.dateStr
        dueDateTextField.text = dateFormatter.string(from: datePicker.date)
        
        ///dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    @IBAction func onPressSave(_ sender: Any) {
        self.view.endEditing(true)
        ///Basic validations
        if let titleStr = titleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let dateStr = dueDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           titleStr.count > 0,
           dateStr.count > 0 {
            //Check if need to update
            if let updateTodo = self.todoUpdateObj {
                
                //updating todo
                let updateTitle = ((updateTodo.name ?? titleStr) == titleStr) ? nil : titleStr
                let updateDate = ((updateTodo.due_on) == datePicker.date) ? nil : datePicker.date
                
                let descStr = getDescriptionString()
                
                let vm = AddNewTaskViewModel(todoObj: updateTodo)
                vm.updateTask(todoObj: updateTodo, title: updateTitle, descriptionStr: descStr, dueDate: updateDate
                              , completion: { (success) in
                                    print("success \(success)")
                                    self.navigationController?.popViewController(animated: true)
                              })
            } else {
                //Adding new todo
                let descStr = getDescriptionString()
                let vm = AddNewTaskViewModel(name: titleStr, descriptionStr: descStr, dueDate: datePicker.date)
                vm.saveTask { (success) in
                    print("success \(success)")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func getDescriptionString() -> String? {
        if let descriptionStr = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           descriptionStr != descriptionPlaceHolder {
            return descriptionStr
        }
        return nil
    }
    
}


extension AddUpdateTodoController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (descriptionTextView.text == descriptionPlaceHolder)
        {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.darkGray
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty
        {
            descriptionTextView.text = descriptionPlaceHolder
            descriptionTextView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
}


