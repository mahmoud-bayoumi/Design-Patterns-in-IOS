//
//  CustomTableViewController.swift
//  CustomNibFileLab_Day2
//
//  Created by Bayoumi on 04/05/2026.
//

import UIKit

class CustomTableViewController: UITableViewController {
    
    private var cards : [Card] = [
        Card(name: "John Doe",   image: UIImage(systemName:"person.circle")),
        Card(name: "Jane Smith", image: UIImage(systemName: "person.circle")),
        Card(name: "Alex Brown", image: UIImage(systemName: "person.circle")),
        Card(name: "Sara White", image: UIImage(systemName: "person.circle")),
        Card(name: "Mike Black", image: UIImage(systemName: "person.circle")),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()


        title = "Cards"
        registerCell()
    }
    private func registerCell(){
        let nib = UINib(nibName: CustomTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cards.count
    }

    override func tableView(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           guard let cell = tableView.dequeueReusableCell(
               withIdentifier: CustomTableViewCell.identifier,
               for: indexPath
           ) as? CustomTableViewCell else {
               return UITableViewCell()
           }

           let card = cards[indexPath.row]
           cell.configure(name: card.name, image: card.image)
           return cell
       }

    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = cards[indexPath.row]
        print("Selected: \(selected.name)")
    }
    

}
