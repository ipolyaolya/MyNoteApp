//
//  NoteTableViewCell.swift
//  NotesApp
//
//  Created by olli on 21.05.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var noteTextLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    func configureWith(text: String?, date: NSDate?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy  HH:mm"
        
        self.noteTextLabel.text = text
        self.dateLabel.text = dateFormatter.string(from: date! as Date)
    }
    
}
