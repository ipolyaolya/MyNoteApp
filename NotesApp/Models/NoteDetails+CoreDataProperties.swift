//
//  NoteDetails+CoreDataProperties.swift
//  NotesApp
//
//  Created by olli on 22.05.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//
//

import Foundation
import CoreData

extension NoteDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteDetails> {
        return NSFetchRequest<NoteDetails>(entityName: "NoteDetails")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?

}

extension NoteDetails {

}
