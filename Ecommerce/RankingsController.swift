//
//  RankingsController.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 14/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import UIKit
import CoreData

class RankingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var rankingObject: Ranking?
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Ranking.self))
//        let predicate = NSPredicate(format: "rankingName != nil")
//        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rankingName", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self as! NSFetchedResultsControllerDelegate
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try self.fetchedhResultController.performFetch()
        } catch let error  {
            print("Error = \(error)")
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            print("count===\(count)")
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell")
        let ranking = fetchedhResultController.sections?[0].objects?[indexPath.row] as! Ranking
        cell?.textLabel?.text = ranking.rankingName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let prodRankVC = UIStoryboard(name: "ProductsRanking", bundle: nil).instantiateViewController(withIdentifier: "prodRankVC") as? ProductsRankingController {
            let prodRanking = fetchedhResultController.sections?[0].objects?[indexPath.row] as! Ranking
            prodRankVC.rankingObject = prodRanking
            self.navigationController?.pushViewController(prodRankVC, animated: true)
        }
    }
}

extension RankingsController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
}
