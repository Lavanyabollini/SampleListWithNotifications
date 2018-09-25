//
//  ListViewController.swift
//  SampleList
//
//  Created by TailWebs on 06/08/18.
//  Copyright © 2018 Tailwebs. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDelegate {
    var details: [NSManagedObject] = []
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //fetching records from coredata
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserDetails")
        do {
            details = try managedContext.fetch(fetchRequest)
        } catch
            let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //removing empty tableview cells
        listTableView.tableFooterView = UIView(frame: .zero)
    }
    
    
    //MARK:-IBAction
    @IBAction func  backButtonClicked(sender:Any){
        dismiss(animated: true, completion: nil)
    }
}
extension ListViewController: UITableViewDataSource {
    
    //MARK:- UITableview datsource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell:ListTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell",
                                              for: indexPath) as! ListTableViewCell
            let detailValues =  details[indexPath.row]
            cell.nameLabel?.text =
                detailValues.value(forKeyPath: "name") as? String
            cell.subjectLabel.text = detailValues.value(forKeyPath: "subject") as? String
            cell.scoreLabel.text = detailValues.value(forKeyPath: "score") as? String
            return cell
    }
    
    //MARK:-UItableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
