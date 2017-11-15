//
//  ProductController.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 14/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import UIKit

class ProductController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var category: Category?
    var products: NSSet?
    var fromWhichPage: String?
    var productsArray: Array<Product> = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Products"
        if fromWhichPage == "SubCategory" {
            for product in (category?.products)! {
                productsArray.append(product as! Product)
            }
        }
    
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (category?.products?.count)!
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as? ProductCell
        let product = productsArray[indexPath.row]
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        cell?.titleLabel?.numberOfLines = 0
        cell?.titleLabel?.text = product.productName
        cell?.detailLabelText?.numberOfLines = 0
        cell?.detailLabelText?.text = "Added on \(product.dateAdded! )\nOnly \(product.variants?.count ?? 0) items are available\nTAX : \(product.taxName ?? "Null")(\(product.taxValue))"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productsArray[indexPath.row]
        if let variantVC = UIStoryboard(name: "Variant", bundle: nil).instantiateViewController(withIdentifier: "variantVC") as? VariantController {
            variantVC.product = product
            self.navigationController?.pushViewController(variantVC, animated: true)
        }
    }

}
