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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allNotes: [NoteDetails]?
    var filteredNotes: [NoteDetails]?
    var isSearching = false
    
    enum SortDetails {
        case descending
        case ascending
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showResults { [weak self] notes in
            self?.allNotes = notes
            if let searchText = self?.searchBar.text, !searchText.isEmpty {
                self?.filteredNotes = notes.filter { ($0.text?.lowercased().contains(searchText.lowercased()))! }
            } else {
                self?.filteredNotes = notes
            }
            
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func sortAction(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let descendingAlertAction = UIAlertAction(title: "From old to new ", style: .default) {[weak self] (action) in
            self?.sortNotes(plus: .descending)
            self?.tableView.reloadData()
        }
        
        let ascendingAlertAction = UIAlertAction(title: "From new to old", style: .default) {[weak self] (action) in
            self?.sortNotes(plus: .ascending)
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
        if editingStyle == .delete, let note = filteredNotes?[indexPath.row] {
            DatabaseController.getContext().delete(note)
            filteredNotes?.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .bottom)
            tableView.endUpdates()
            DatabaseController.saveContext()
            
            showResults { [weak self] notes in
                self?.allNotes = notes
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        let note: NoteDetails?
        
        note = filteredNotes?[indexPath.row]
        
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
        controller.note = filteredNotes?[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Private functions
    
    private func showResults(completion: (([NoteDetails]) -> Void)?) {
        let fetchRequest: NSFetchRequest<NoteDetails> = NoteDetails.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest) as [NoteDetails]
            completion?(searchResults)
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    func sortNotes(plus details: SortDetails) {
        switch details {
        case .ascending:
            filteredNotes?.sort { $0.date?.compare($1.date! as Date) == .orderedAscending }
        case .descending:
            filteredNotes?.sort { $0.date?.compare($1.date! as Date) == .orderedDescending }
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNotes = allNotes?.filter{($0.text?.lowercased().contains(searchText.lowercased()))!}
        tableView.reloadData()
        if searchBar.text == "" {
            filteredNotes = allNotes
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredNotes = allNotes
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredNotes = allNotes
        searchBar.endEditing(true)
    }

}

