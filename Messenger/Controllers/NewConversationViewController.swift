//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Sahil Kumar Bansal on 28/10/21.
//

import UIKit
import JGProgressHUD
class NewConversationViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    private let noResultsLabel: UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text  = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }

   

}
extension NewConversationViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
