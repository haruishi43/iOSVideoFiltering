//
//  FilterSelectionViewController.swift
//  AVVideoEditor
//
//  Created by Haruya Ishikawa on 2017/10/05.
//  Copyright © 2017 Haruya Ishikawa. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    static let reuseIdentifier = "FilterCell"
    
    @IBOutlet weak var filterTitleLabel: UILabel!
    
    var name = "" {
        didSet {
            filterTitleLabel.text = name
        }
    }
    
}

protocol FilterSelectionViewControllerDelegate: class {
    func filterSelectionViewController(_ selectionViewController: FilterSelectionViewController, didSelectFilter: Filter)
    func filterSelectionViewController(_ selectionViewController: FilterSelectionViewController, didDeselectFilter: Filter)
    
}

class FilterSelectionViewController: UITableViewController {
    
    var filters = [Filter]()
    
    var selectedFilterRows = IndexSet()
    
    weak var delegate: FilterSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 200, height: tableView.contentSize.height)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        dismiss(animated: false, completion: nil)
        // Check if the current row is already selected, then deselect it.
        if selectedFilterRows.contains(indexPath.row) {
            delegate?.filterSelectionViewController(self, didDeselectFilter: filter)
        } else {
            delegate?.filterSelectionViewController(self, didSelectFilter: filter)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
            fatalError("Expected `\(FilterCell.self)` type for reuseIdentifier \(FilterCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        cell.name = filters[indexPath.row].name
        
        if selectedFilterRows.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }
    
}

