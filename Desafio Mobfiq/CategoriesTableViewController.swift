//
//  CategoriesTableViewController.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import UIKit

private let reuseCellIdentifier = "Cell"

class CategoriesTableViewController: UITableViewController {
    
    var categories : [CategoryViewModel] = [CategoryViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if categories.count == 0 {
            // activity indicator
            let indicator = UIActivityIndicatorView(frame: self.view.bounds)
            indicator.activityIndicatorViewStyle = .gray
            
            self.view.addSubview(indicator)
            
            indicator.isUserInteractionEnabled = false
            indicator.startAnimating()
            
            self.tableView!.separatorStyle = .none
            
            let service = StorePreferenceService(RestApiClient())
            
            service.fetchCategoryTree() { (success, object) -> () in
                if success {
                    let tree = object as! CategoryTree
                    
                    // model --> viewmodel
                    for category in tree.categories {
                        self.categories.append(CategoryViewModel(with: category))
                    }
                    
                    // presenting it
                    DispatchQueue.main.async {
                        self.tableView!.separatorStyle = .singleLine
                        
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                        
                        self.tableView!.reloadData()
                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = self.categories[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories[indexPath.row].category.subcategories.count > 0 {
            let subcategoryViewController = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "SBCategoriasViewController") as! CategoriesTableViewController
            
            var subcategories = [CategoryViewModel]()
            for category in categories[indexPath.row].category.subcategories {
                subcategories.append(CategoryViewModel(with: category))
            }
            
            subcategoryViewController.categories = subcategories
            subcategoryViewController.navigationItem.title = categories[indexPath.row].title
            self.navigationController?.pushViewController(subcategoryViewController, animated:true)
        }
        else {
            self.performSegue(withIdentifier: "ProductsFromCategorySegue", sender: indexPath)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ProductsFromCategorySegue") {
        
            let productViewController = segue.destination as! ProductsCollectionViewController
            let indexPath = sender as! IndexPath
        
            productViewController.fromCategory = indexPath.row == 0 ? self.navigationItem.title : self.categories[indexPath.row].title
            productViewController.initialCriteria = self.categories[indexPath.row].category.redirect?.searchCriteria
        }
    }
    

}
