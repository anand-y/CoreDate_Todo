//
//  TodoListTableViewCell.swift
//  CoreData_Todo
//
//  Created by Shreenivas on 05/08/21.
//

import UIKit

class TodoListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "todoListTableViewCell"
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var todo: Todo? {
        didSet {
            if let todoObj = todo {
                titleLabel.text = todoObj.name ?? nil
                descriptionLabel.text = todoObj.descrip
                if let dueDate = todoObj.due_on {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = DateFormatter.DateFormatString.dateStr
                    dueDateLabel.text = "Due On: " + dateFormatter.string(from: dueDate)
                }else{
                    dueDateLabel.text = nil
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
