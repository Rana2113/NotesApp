//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by Rana Mustafa on 02/06/2025.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleNote: UILabel!
    
    @IBOutlet weak var contentNote: UILabel!
    
    @IBOutlet weak var createAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
