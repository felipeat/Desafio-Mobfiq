//
//  ProductsCollectionViewController.swift
//  Desafio Mobfiq
//
//  Created by Pro on 27/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import UIKit

private let reuseCellIdentifier = "Cell"
private let reuseHeaderIdentifier = "Header"

class ProductsCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var searchController: UISearchController?
    
    var searchResult : SearchResultViewModel? = nil
    
    var products : [ProductViewModel] = []
    
    var fromCategory: String?
    var initialCriteria: [String : Any?]?
    
    var criteria: [String : Any?]?
    
    var currentCollectionViewState: NSMutableDictionary = [:]
    
    let kLastCellIndex = "LastCellIndex"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController!.definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        
        // Do any additional setup after loading the view.
        
        if self.fromCategory == nil {
            self.fromCategory = "Todos os produtos"
        }
        
        // retrieving data...
        if self.initialCriteria == nil {
            let criteriaBuilder = SearchCriteriaBuilder()
            self.initialCriteria = criteriaBuilder.simpleCriteriaObject(withQuery: "")
        }
        self.loadDataWithCriteria(self.initialCriteria!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        // Configure the cell
        cell.productNameLabel.text = self.products[indexPath.row].productNameText ?? ""
        
        let attributes: [String:Any] = [NSStrikethroughStyleAttributeName : NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)]
        cell.previousPriceLabel.attributedText = NSAttributedString(string: self.products[indexPath.row].previousPriceText ?? "", attributes: attributes)
        
        cell.currentPriceLabel.text = self.products[indexPath.row].currentPriceText ?? ""
        cell.installmentLabel.text = self.products[indexPath.row].installmentText ?? ""
        
        // default pic
        cell.productPhotoImageView.image = UIImage(named: "static-loading")
        
        // real pic
        if let picUrlString = self.products[indexPath.row].productPhotoUrlString {
            let pictureUrl = URL(string: picUrlString)!
            
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: pictureUrl) { (data, response, error) in
                if let e = error  {
                    print("Error downloading picture \(e)")
                }
                else {
                    if let res = response as? HTTPURLResponse, res.statusCode == 200 {
                        if let imageData = data {
                            DispatchQueue.main.async {
                                cell.productPhotoImageView.image = UIImage(data: imageData)
                            }
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
        }
        
        
        // TODO - avaliar se vale a pena mudar para uns dos delegates do collection view
        if (indexPath.row + 1) % 10 == 0 && self.currentCollectionViewState[kLastCellIndex] as! Int != (indexPath.row + 1) {
            self.currentCollectionViewState[kLastCellIndex] = indexPath.row + 1
        }
        // end TODO
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath)
        
        // Configure the cell
        let headerCell = cell as! HeaderCollectionReusableView
        headerCell.resultCount!.text = String(0)
        
        if self.searchResult != nil {
            headerCell.resultCount!.text = String(self.searchResult!.total)
            
            if let query = self.criteria!["Query"] as? String,
                query.characters.count > 0 {
                headerCell.userStateTitle!.text = "Você buscou por:"
                headerCell.lastQueryTitle!.text = query
                
            }
            else {
                headerCell.userStateTitle!.text = "Você está em:"
                headerCell.lastQueryTitle!.text = fromCategory!
            }
            
        }
        
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    // MARK: observer
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let newOffset = change?[.newKey] as? Int {
            
            if newOffset > 0 {
                
                let service = ProductSearchService(RestApiClient())
                
                self.criteria!["Offset"] = newOffset
                
                service.query(withSearchCriteria: self.criteria!) { (success, object) -> () in
                    if success {
                        let result = object as! SearchResult
                        
                        // model --> viewmodel
                        self.searchResult = SearchResultViewModel(with: result)
                        for product in result.products {
                            self.products.append(ProductViewModel(withProduct: product))
                        }
                        
                        DispatchQueue.main.async {
                            self.collectionView!.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: Search Bar
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController!.searchBar.delegate = self
        self.searchController!.searchBar.text = self.criteria?["Query"] as? String
        
        // "enablesReturnKeyAutomatically = false" permite que o usuário busque por uma string vazia 
        self.searchController!.searchBar.enablesReturnKeyAutomatically = false
        
        self.navigationController!.present(searchController!, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedText = searchBar.text {
            self.searchController!.isActive = false
            if searchedText.characters.count > 0 {
                let criteriaBuilder = SearchCriteriaBuilder()
                let criteriaWithUserQuery = criteriaBuilder.simpleCriteriaObject(withQuery: searchedText)
                self.loadDataWithCriteria(criteriaWithUserQuery)
            }
            else {
                self.loadDataWithCriteria(self.initialCriteria!)
            }
        }
    }
    
    // MARK: custom methods
    
    func loadDataWithCriteria(_ criteria: [String : Any?]) {
        
        self.view.backgroundColor = UIColor.white
        
        // activity indicator
        let indicator = UIActivityIndicatorView(frame: self.view.bounds)
        indicator.activityIndicatorViewStyle = .gray
        
        self.view.addSubview(indicator)
        
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        let bgColor = self.collectionView?.backgroundColor
        self.collectionView?.backgroundColor = UIColor.clear
        
        self.criteria = criteria
        self.searchResult = nil
        self.clearCollectionView()
        
        let service = ProductSearchService(RestApiClient())
        
        service.query(withSearchCriteria: criteria) { (success, object) -> () in
            if success {
                let result = object as! SearchResult
                
                // model --> viewmodel
                self.searchResult = SearchResultViewModel(with: result)
                for product in result.products {
                    self.products.append(ProductViewModel(withProduct: product))
                }
                
                // presenting it
                DispatchQueue.main.async {
                    self.collectionView?.backgroundColor = bgColor
                    
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    
                    self.collectionView!.reloadData()
                }
            }
        }
        
        self.currentCollectionViewState.addObserver(self, forKeyPath: kLastCellIndex, options: .new, context: nil)
    }
    
    func clearCollectionView() {
        self.products.removeAll()
        self.currentCollectionViewState[kLastCellIndex] = 0
        self.collectionView!.reloadData()
    }
    
    
}
