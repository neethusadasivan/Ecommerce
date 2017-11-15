//
//  VariantController.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 14/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import UIKit

class VariantController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var product: Product?
    var variantsArray: Array<Variant> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Variants"
        
        for variant in (product?.variants)! {
            variantsArray.append(variant as! Variant)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let variants = product?.variants {
            return variants.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let variant = variantsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "variantCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        cell?.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.textLabel?.text = variant.variantColor
        //cell?.detailTextLabel?.textAlignment = .center
        cell?.detailTextLabel?.text = "Color: \(variant.variantPrize)\nPrize: \(variant.variantSize)"
        return cell!
    }
}
