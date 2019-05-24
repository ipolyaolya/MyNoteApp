//
//  NoteDetailsViewController.swift
//  NotesApp
//
//  Created by olli on 22.05.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailsViewController: UIViewController {
    
    @IBOutlet private weak var noteTextView: UITextView!
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    
    var note: NoteDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Buttons
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        if noteTextView.text.count >= 1{
            addNote(note)
        } else {
            print("Мне мало мало мало")
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        guard let noteShare = note else { return }
        let itemsToShare = [noteShare.text]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare as [Any], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Private functions
    
    private func setupUI() {
        
        if note?.text != nil {
            saveBarButton.title = ""
            noteTextView.text = note?.text
            noteTextView.becomeFirstResponder()
            
        } else {
            saveBarButton.title = "Save"
            noteTextView.text = note?.text
        }
    }
    
    private func addNote(_ note: NoteDetails?) {

        if let note = note {
            saveNote(note)
        } else {
            
            let noteDetails = NSEntityDescription.insertNewObject(forEntityName: "NoteDetails", into: DatabaseController.getContext()) as! NoteDetails
            saveNote(noteDetails)
        }
    }
    
    private func saveNote(_ note: NoteDetails) {
        note.text = noteTextView.text
        note.date = Date() as NSDate
        
        DatabaseController.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}

    //MARK: - Extension

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        saveBarButton.title = "Save"
    }
}
