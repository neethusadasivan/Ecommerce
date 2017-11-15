//
//  SubCategoryController.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 14/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import UIKit
import CoreData

class SubCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var categoryObject: Category?
    var subCategoriesArray: Array<Category> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("category name = \(String(describing: categoryObject?.categoryName))")
        tableView.backgroundColor = UIColor.darkGray
        
        self.navigationItem.title = "Sub Categories"
        //Fetch sub categories
        if let subCategories = categoryObject?.subCategories {
            for i in subCategories {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Category.self))
                let predicate = NSPredicate(format: "categoryID == \(i)")
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryID", ascending: true)]
                let fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
                
                do {
                    try fetchedhResultController.performFetch()
                } catch let error  {
                    print("Error = \(error)")
                }
                
                subCategoriesArray.append(fetchedhResultController.sections?[0].objects?[0] as! Category)
            }
            print("subCategoriesArray===\(subCategoriesArray)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (categoryObject?.subCategories.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCategoryCell")
        let subCategory = subCategoriesArray[indexPath.row]
        cell?.textLabel?.text = subCategory.categoryName
        if subCategory.subCategories.count != 0 {
            cell?.detailTextLabel?.text = "\(subCategory.subCategories.count) subcategories"
        }
        else {
            cell?.detailTextLabel?.text = "\(subCategory.products?.count ?? 0) products"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subCategory = subCategoriesArray[indexPath.row]
        if subCategory.subCategories.count == 0 {
            if let productVC = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "productVC") as? ProductController {
                productVC.fromWhichPage = "SubCategory"
                productVC.category = subCategory
                self.navigationController?.pushViewController(productVC, animated: true)
            }
        }
        else {
            if let subCategoryVC = UIStoryboard(name: "SubCategoryStoryboard", bundle: nil).instantiateViewController(withIdentifier: "subCategoryVC") as? SubCategoryController {
                subCategoryVC.categoryObject = subCategory
                self.navigationController?.pushViewController(subCategoryVC, animated: true)
            }
        }
    }

}
