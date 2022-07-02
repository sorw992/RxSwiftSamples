
//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//

import UIKit

import RxSwift
import RxCocoa

class ViewControllerTabCounter: UIViewController {
    
    
    @IBOutlet weak var btnTap: UIButton!
    
    @IBOutlet weak var btnReset: UIBarButtonItem!
    
    @IBOutlet weak var labelNumber: UILabel!
    
    fileprivate let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnTap.rx.tap.subscribe({ [weak self] _ in
            
            guard let this = self else {
                return
            }
            
            guard let text = this.labelNumber.text else {
                return
            }
            
            guard let number = Int(text) else {
                return
            }
            
            this.labelNumber.text = String(number + 1)
            
        }).disposed(by: disposeBag)
        
        
        btnReset.rx.tap.subscribe({ [weak self] _ in
            
            guard let this = self else {
                return
            }
            
            this.labelNumber.text = "0"
            
            
        }).disposed(by: disposeBag)
        
        
    }
    
    
}

