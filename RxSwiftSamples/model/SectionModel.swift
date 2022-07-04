//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//

import Foundation

// we used it to split our table view in sections. for this we defined SectionModel structure and updated our BehaviorRelay for foods to use it then we created an rxdatasource object
import RxDataSources

// use two section for dessert and main food
struct SectionModel {
    
    var header: String
    var items: [Food]
    
}

// RxDataSources require us to implement the SectionModelType delegate
extension SectionModel: SectionModelType {
 
    init(original: SectionModel, items: [Food]) {
        self = original
        self.items = items
    }
    
}
