
//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//

import UIKit
import RxSwift
import RxCocoa

// Reactive View Controller

class ViewControllerFoodDetail: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // non reactive way
    // var imageName: String = "";
    
    //Rx
    // Behavior Relay emits string element and initialized with an empty value
    // emitted to UIImage Object
    let imageName: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    // disposeBag to take care of memory management
    // we already decalred it in main view conteller so we name it disposeBag2
    let disposeBag2 = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // non reactive way
        // imageView.image = UIImage.init(named: imageName)
        
        // map operator is used to transform the values emitted by an observable
        // elem get transformed according to our needs
        imageName.map {
            name in
            
            // problem - debugging memory leaks
            // print("Resources count: \(RxSwift.Resources)")
            
            UIImage.init(named: name)
        }
        // we use bind() method to bind the UIImage object to the imageView's image
        .bind(to: imageView
        
            .rx
            .image)
        // finally lets take care of memory management with disposeBag
        .disposed(by: disposeBag2)
        
        
    }
    
}
