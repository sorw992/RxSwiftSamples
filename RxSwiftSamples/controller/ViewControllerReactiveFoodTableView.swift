
//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewControllerReactiveFoodTableView: UIViewController {
    
    // 1- transform our array of strings into an observable sequence that will become the datasource of the table view. this will be the datasource for table view. so whe have to use Observable.just() operator
    //let tableViewItems = ["item 1", "item 2", "item 3", "item 4"]
    // just operator means our observable will emit all these four elements
    // we have to transform our observable to a behavior relay because tableViewItems that is an Observable doesn't allow us to access directy the array that it emits and we won't be able to filter it when we perform the search. that's why we need to transform it to a behavior relay.
    /* let tableViewItems = Observable.just([
     Food(name: "Hamburger", image: "hamburger"),
     Food(name: "Pizza", image: "pizza"),
     Food(name: "Salmon", image: "salmon"),
     Food(name: "Spaghetti", image: "spaghetti"),
     Food(name: "Cake", image: "cake"),
     Food(name: "Tiramisu", image: "tiramisu"),
     Food(name: "Ribs", image: "ribs"),
     Food(name: "Saladveggy", image: "saladveggy"),
     Food(name: "Saladcheese", image: "saladcheese"),
     Food(name: "Curry", image: "curry"),
     Food(name: "Clubsandwich", image: "clubsandwich"),
     Food(name: "Pancake", image: "pancake")
     ]) */
    /* let tableViewItems = BehaviorRelay.init(value: [
        Food(name: "Hamburger", image: "hamburger"),
        Food(name: "Pizza", image: "pizza"),
        Food(name: "Salmon", image: "salmon"),
        Food(name: "Spaghetti", image: "spaghetti"),
        Food(name: "Cake", image: "cake"),
        Food(name: "Tiramisu", image: "tiramisu"),
        Food(name: "Ribs", image: "ribs"),
        Food(name: "Saladveggy", image: "saladveggy"),
        Food(name: "Saladcheese", image: "saladcheese"),
        Food(name: "Curry", image: "curry"),
        Food(name: "Clubsandwich", image: "clubsandwich"),
        Food(name: "Pancake", image: "pancake")
    ]) */
    
    // array of section model objects
    // we defined SectionModel structure and updated our BehaviorRelay for foods to use it then we created an rxdatasource object and specified how to display our sections with the aid of configureCell and titleForHeaderInSection methods, finally we bind the dataSource to the table view's rows
    let tableViewItemsSectioned = BehaviorRelay.init(value: [
        SectionModel(header: "Main Courses", items: [Food(name: "Hamburger", image: "hamburger"),
                                                     Food(name: "Pizza", image: "pizza"),
                                                     Food(name: "Salmon", image: "salmon"),
                                                     Food(name: "Spaghetti", image: "spaghetti"),
                                                     Food(name: "Ribs", image: "ribs"),
                                                     Food(name: "Clubsandwich", image: "clubsandwich")]),
        SectionModel(header: "Deserts", items: [Food(name: "Cake", image: "cake"),
                     Food(name: "Tiramisu", image: "tiramisu"),
                     Food(name: "Saladveggy", image: "saladveggy"),
                     Food(name: "Saladcheese", image: "saladcheese"),
                     Food(name: "Curry", image: "curry"),
                     Food(name: "Pancake", image: "pancake")])
    ])
    
    let disposebag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // instantiate RxTableViewSectionedReloadDataSource - it will contain an array of section models and will describe how each tableviewcell will look like - we do that with the aid of configureCell title
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
        // this closure just receives data source as well among the other arguments
        // ds is datasource
        // tv is table view
        ds, tv, indexP, item in
        //print("indexP", indexP.row)
        // instantiate a cell
        let cell : FoodTableViewCell = tv.dequeueReusableCell(withIdentifier: "apiCell", for: indexP) as! FoodTableViewCell
        
        cell.foodLabel.text = item.name
        cell.foodImageView.image = UIImage.init(named: item.image)
        return cell
    },
    titleForHeaderInSection: {
        // ds is datasource
        // index of the section model (we have two section model so index is 0 or 1)
        ds, index in
        //print("index", index)
        
        // return header of the section model
        return ds.sectionModels[index].header
        
    }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Summary: we used rx text Observable property from the searchBar in order to obtain the query issued by the user then we used a map to filter operators in order to obtain the filter food items and finally we bind the dataSource to the table view's rows
        // text is an Observable property offered by RxCocoa and in case the searchBar is empty, we still want to display all the food items so we are using orEmpty for that
        // add a bit delay after user types in, we use throttle for that and add 300 milliseconds on main scheduler
        let foodQuery = searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        
        // protect us from the same values
            .distinctUntilChanged()
        
        // use map operator to return filtered values
            .map ({
                query in
                
                // we used map operator in order to filter the items array inside each section model
                self.tableViewItemsSectioned.value.map({
                    sectionModel in
                    // we used filter operator for this and we receive each food object
                    SectionModel(header: sectionModel.header, items: sectionModel.items.filter({
                        food in
                        
                        // all that is it checks that it contains the query or if the query is empty, we still want to see the values on the screen
                        query.isEmpty || food.name.lowercased().contains(query.lowercased())
                    }))
                })
            })
        
        // bind the rows in the table view to the datasource - we will do that using rx.items(dataSource:) method
            .bind(to: tableView
            .rx
            .items(dataSource: dataSource))
               
        // take care of memory management
            .disposed(by: disposebag)
        
        
        // rx version of UITableView's didSelectRowAt method
        // model is used to display the rows in our table view
        // Food.self is an observable that we need to subscribe to it using subscribe method
        tableView
        // modelSelected is for receiving modal object and itemSelected receives indexpath (classic)
            .rx.modelSelected(Food.self)
        
            .subscribe { foodObject in
                // onNext method
                let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerFoodDetail") as! ViewControllerFoodDetail
                //foodVC.imageName = foodObject.image
                
                // imageName is a behavior relay so we need to accept food object image
                foodVC.imageName.accept(foodObject.image)
                
                self.navigationController?.pushViewController(foodVC, animated: true)
                
                
            } onError: { error in
                print("error", error.localizedDescription)
            } onCompleted: {
                
            } onDisposed: {
                
            }
        
            .disposed(by: disposebag)
        
        
        // modelSelected is for receiving modal object and itemSelected receives indexpath (classic)
        // if you need to work with indexpath, u can use itemSelected method
        tableView
            .rx
            .itemSelected
            .subscribe { indexPath in
                
                // on next
                
                print("indexpath.row", indexPath.row)
                
            } onError: { error in
                print("error", error.localizedDescription)
            } onCompleted: {
                
            } onDisposed: {
                
            }
            .disposed(by: disposebag)
        
        
        // todo: question set cell height with rxswift
        
    }
    
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerFoodDetail") as! ViewControllerFoodDetail
     
     foodVC.imageName = "hamburger"
     
     self.navigationController?.pushViewController(self, animated: true)
     
     }
     
     */
    
    
    
}


extension ViewControllerReactiveFoodTableView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
    
}
