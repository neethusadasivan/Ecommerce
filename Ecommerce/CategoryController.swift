//
//  CategoryViewController.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 13/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import UIKit
import CoreData

class CategoryController: UIViewController, APIControllerProtocol {

    let api = APIController()
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let context = CoreDataStack.sharedInstance.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActivityIndicator()
        api.delegate = self
        
        myActivityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.api.fetchJSONData(urlString: "https://stark-spire-93433.herokuapp.com/json")
        }

    }
    
    func addActivityIndicator() {
        myActivityIndicator.center = view.center
        //myActivityIndicator.activityIndicatorViewStyle = .gray
        myActivityIndicator.activityIndicatorViewStyle = .whiteLarge
        myActivityIndicator.backgroundColor = UIColor.lightGray
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func createCategoryEntityFrom(dictionary: [String: Any]) -> NSManagedObject? {
        
        /*
         guard let titleDict = json[Key.titleDict] as? [String: AnyObject],
         let title = titleDict[Key.label] as? String,
         let imageURLArray = json[Key.imageURLArray] as? [[String: AnyObject]],
         let imageURL = imageURLArray.last?[Key.label] as? String,
         let releaseDateDict = json[Key.releaseDateDict] as? [String: AnyObject],
         let releaseDateAttributes = releaseDateDict[Key.attributes],
         let releaseDate = releaseDateAttributes[Key.label] as? String,
         let purchasePriceDict = json[Key.purchacePriceDict] as? [String: AnyObject],
         let purchasePriceAttributes = purchasePriceDict[Key.attributes] as? [String: AnyObject],
         let priceAmount = purchasePriceAttributes[Key.amount] as? String,
         let priceCurrency = purchasePriceAttributes[Key.currency] as? String
         else {
         return nil
         }

         */
        if let categoryEntity = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category {
            guard let categoryID = dictionary["id"] as? Int16 else {
                return nil
            }
            categoryEntity.categoryID = categoryID
            categoryEntity.categoryName = dictionary["name"] as? String
            if let products = dictionary["products"] as? [[String: Any]] {
                for product in products {
                    let productEntity = createProductEntityFrom(dictionary: product, category: categoryEntity)
                    categoryEntity.products = NSSet(object: productEntity as! Product)
                }
//                do {
//                    try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
//                } catch let error {
//                    print(error)
//                }
            }
            if let childCategories = dictionary["child_categories"] as? [[String: Any]] {
                for subCategory in childCategories {
                    let subCategoryEntity = createSubCategoryEntityFrom(dictionary: subCategory, category: categoryEntity)
                    categoryEntity.subcategories = NSSet(object: subCategoryEntity as! Category)
                }
//                do {
//                    try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
//                } catch let error {
//                    print(error)
//                }
            }
            return categoryEntity
        }
        return nil
    }
    
    private func createProductEntityFrom(dictionary: [String: Any], category: NSManagedObject) -> NSManagedObject? {
        
        if let productEntity = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as? Product {
            
            guard let productID = dictionary["id"] as? Int16 else {
                return nil
            }
            productEntity.productID = productID
            productEntity.productName = dictionary["name"] as? String
            productEntity.dateAdded = dictionary["date_added"] as? String
            if let tax = dictionary["tax"] as? [String: Any] {
                productEntity.taxName = tax["name"] as? String
                productEntity.taxValue = (tax["value"] as? Float)!
            }
            if let variants = dictionary["variants"] as? [[String: Any]] {
                for variant in variants {
                    let variantEntity = createVariantEntityFrom(dictionary: variant, product: productEntity)
                    productEntity.variants = NSSet(object: variantEntity as! Variant)
                    
                }
                
            }
            return productEntity
        }
        return nil
        
    }
    
    private func createVariantEntityFrom(dictionary: [String: Any], product: NSManagedObject) -> NSManagedObject? {
        print("variant dictionary = \(dictionary)")
        if let variantEntity = NSEntityDescription.insertNewObject(forEntityName: "Variant", into: context) as? Variant {
            guard let variantID = dictionary["id"] as? Int16 else {
                return nil
            }
            variantEntity.variantID = variantID
            variantEntity.variantColor = dictionary["color"] as? String
            if let variantSize = dictionary["size"] as? Int16  {
                variantEntity.variantSize = variantSize
            }
            if let variantPrize = dictionary["price"] as? Int32  {
                variantEntity.variantPrize = variantPrize
            }
            
            return variantEntity
        }
        return nil
    }
    
    private func createSubCategoryEntityFrom(dictionary: Dictionary<String, Any>, category: NSManagedObject) -> NSManagedObject? {
        if let subcategoryEntity = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category {
            guard let categoryID = dictionary["id"] as? Int16 else {
                return nil
            }
            subcategoryEntity.categoryID = categoryID
            subcategoryEntity.categoryName = dictionary["name"] as? String
            return subcategoryEntity
        }
        return nil
    }
    
    //private func createRankingEntityFrom(dictionary: [String: Any]) -> NSManagedObject? {
        
//        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Ranking", into: context) as? Ranking {
//            photoEntity.author = dictionary["author"] as? String
//            photoEntity.tags = dictionary["tags"] as? String
//            let mediaDictionary = dictionary["media"] as? [String: Any]
//            photoEntity.mediaURL = mediaDictionary?["m"] as? String
//            return photoEntity
//        }
//        return nil
    //}
    
    private func saveInCategoryDataWith(array: [[String: Any]]) {
        _ = array.map{self.createCategoryEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
//    private func saveInRankingDataWith(array: [[String: Any]]) {
//        _ = array.map{self.createRankingEntityFrom(dictionary: $0)}
//        do {
//            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
//        } catch let error {
//            print(error)
//        }
//    }
    
    func didReceiveAPIResults(_ results: Dictionary<String, Any>) {
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.myActivityIndicator.stopAnimating()
        }

        print("results====\(results)")
        guard let jsonData = results["json_data"] as? [String: Any] else {
            DispatchQueue.main.async {
                if let error = results["error"] as? String {
                    self.showAlertWith(title: "Error", message: error)
                }
            }
            return
        }
        guard let categories = jsonData["categories"] as? [[String: Any]] else {
            return
        }
        saveInCategoryDataWith(array: categories)
        guard let rankings = jsonData["rankings"] as? [[String: Any]] else {
            return
        }
        //saveInRankingDataWith(array: rankings)
        
    }

}
