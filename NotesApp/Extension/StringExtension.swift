//
//  StringExtation.swift
//  NotesApp
//
//  Created by olli on 23.05.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import Foundation

extension String {
    func limitLenght(to lenght: Int, trailing: String = "...") -> String {
        return (self.count > lenght) ? self.prefix(lenght) + trailing : self
    }
}
