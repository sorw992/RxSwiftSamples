
//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//

import UIKit
import RxSwift
import RxCocoa


class ViewControllerGettingCurrentDateAndTime: UIViewController {
    
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshButton.rx.tap.map({
            x in
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .medium
            return dateformatter.string(from: Date())
            // bind: question
        }).bind(to: labelDateTime.rx.text).disposed(by: disposeBag)
        
    }
    
}


