//
//  ProductsRankingController.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 15/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import UIKit
import CoreData

class ProductsRankingController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var rankingObject: Ranking?
    var productsArray: Array<ProductRanking> = []
    let context = CoreDataStack.sharedInstance.persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.title = rankingObject?.rankingName!

        let rightBarButton = UIBarButtonItem(title: "SORT ASC", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        for product in (rankingObject?.productrankings)! {
            productsArray.append(product as! ProductRanking)
        }
    }
    
    func rightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        if sender.title == "SORT ASC" {
            sender.title = "SORT DESC"
            productsArray = productsArray.sorted { $0.viewCount < $1.viewCount }
        }
        else {
            sender.title = "SORT ASC"
            productsArray = productsArray.sorted { $0.viewCount > $1.viewCount }
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (rankingObject?.productrankings?.count)!
        return productsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prodRankCell")
        let rankProduct = productsArray[indexPath.row]
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        cell?.textLabel?.numberOfLines = 0
        
        do {
            let predicate = NSPredicate(format: "productID == \(rankProduct.prodID)")
            let fetchProduct = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            fetchProduct.predicate = predicate
            if let results = try context.fetch(fetchProduct) as? [Product] {
                cell?.textLabel?.text = results.first?.productName
            }
        }catch {
            print(error)
        }
        
        
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.text = "Reachability Count : \(rankProduct.viewCount)"
        return cell!
    }
}
