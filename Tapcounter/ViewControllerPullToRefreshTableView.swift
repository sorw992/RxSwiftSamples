
// problem

/*

import UIKit
import RxSwift
import RxCocoa

class ViewControllerPullToRefreshTableView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate let disposeBag = DisposeBag()
    fileprivate let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Variable([
            "Mike",
            "Apples",
            "Ham",
            "Eggs"
            ])
        
        let items2 = [
            "Fish",
            "Carrots",
            "Mike",
            "Apples",
            "Ham",
            "Eggs",
            "Bread",
            "Chiken",
            "Water"
            ]
        
        
        items.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self), curriedArgument: { (row, element, cell) in
                cell.textLabel?.text = element
            }).addDisposableTo(disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                _ in
                items.value = items2
                self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
        tableView.addSubview(refreshControl)
        
    }
    
    
}


*/
