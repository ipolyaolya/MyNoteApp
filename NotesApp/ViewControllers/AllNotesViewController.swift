//
//  AllNotesViewController.swift
//  NotesApp
//
//  Created by olli on 22.05.19.
//  Copyright © 2019 Oli Poli. All rights reserved.
//

import UIKit
import CoreData

class AllNotesViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allNotes: [NoteDetails]?
    var filterAllNotes: [NoteDetails]?
    var isSearching = false
    
    enum SortDetails {
        case up
        case down
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        results()
    }
    
    @IBAction func sortAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let descendingAlertAction = UIAlertAction(title: "From old to new ", style: .default) {[weak self] (action) in
            self?.sortNotes(plus: .down)
            self?.tableView.reloadData()
        }
        let ascendingAlertAction = UIAlertAction(title: "From new to old", style: .default) {[weak self] (action) in
            self?.sortNotes(plus: .up)
            self?.tableView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(descendingAlertAction)
        alertController.addAction(ascendingAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
        
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let note = allNotes?[indexPath.row] {
            DatabaseController.getContext().delete(note)
            allNotes?.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .bottom)
            tableView.endUpdates()
            DatabaseController.saveContext()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filterAllNotes?.count ?? 0
        } else {
            return allNotes?.count ?? 0
        }
}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        let note : NoteDetails?
        
        if isSearching {
            note = filterAllNotes?[indexPath.row]
        } else {
            note = allNotes?[indexPath.row]
        }
        
        cell.configureWith(text: note?.text?.limitLenght(to: 100), date: note?.date)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NoteEditViewController") as! NoteDetailsViewController
        if isSearching {
            controller.note = filterAllNotes?[indexPath.row]
        } else {
            controller.note = allNotes?[indexPath.row]
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Private functions
    
    private func results() {
        let fetchRequest: NSFetchRequest<NoteDetails> = NoteDetails.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest) as [NoteDetails]
            allNotes = searchResults
            tableView.reloadData()
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    private func sortNotes(plus details: SortDetails) {
        switch details {
        case .up:
            allNotes?.sort { $0.date?.compare($1.date! as Date) == .orderedAscending }
        case .down:
            allNotes?.sort { $0.date?.compare($1.date! as Date) == .orderedDescending }
        }
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterAllNotes = allNotes?.filter{($0.text?.lowercased().contains(searchText.lowercased()))!}
        isSearching = true
        tableView.reloadData()
        if searchBar.text == "" {
            isSearching = false
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}



