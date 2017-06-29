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

class ProductsCollectionViewController: UICollectionViewController {
    
    var products : [ProductViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)

        // Do any additional setup after loading the view.
        
        /**************/
        // TESTE / EXPERIMENTO
        let count: Int? = 12
        let value: Double? = 99.98
        let total: Double? = 1199.83

        let bi = BestInstallment(countInst: count, valueInst: value, totalInst: total)
        let product = Product(name: "Teste", skus: [Sku(name: nil, sellers: [Seller(price: total, listPrice: total, bestInstallment: bi)], images: [])])

        products = Array.init(repeating: ProductViewModel(withProduct:product), count: 10)
        // TESTE / EXPERIMENTO
        /*************/
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
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath)
        
        // Configure the cell
        
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

}
