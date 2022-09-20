
import UIKit

class TableViewControllerMainRxSamples: UITableViewController {

    let items = ["Login Check with RxSwift",
                 "RxSwift Table View",
                 "Tap Counter",
                 "Tap or Hold Counter",
                 "Tip Calculator",
                 "Current Date and Time",
                 "Swipe to Dismiss Keyboard",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! MainItemTableViewCell
        
        cell.labelTitle.text = items[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            push(identifier: "ViewControllerLogin", self: self)
        }
        
        if indexPath.row == 1 {
            push(identifier: "ViewControllerReactiveFoodTableView", self: self)
        }
        
        if indexPath.row == 2 {
            push(identifier: "ViewControllerTabCounter", self: self)
        }
        
        if indexPath.row == 3 {
            push(identifier: "ViewControllerTabOrHoldCounter", self: self)
        }
        
        if indexPath.row == 4 {
            push(identifier: "ViewControllerTipCalculator", self: self)
        }
        if indexPath.row == 5 {
            push(identifier: "ViewControllerGettingCurrentDateAndTime", self: self)
        }
        
        if indexPath.row == 6 {
            push(identifier: "ViewControllerSwipeToDismissKeyboard", self: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    

}
