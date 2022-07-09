//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//



import Foundation
import UIKit
import RxSwift
import RxCocoa

class ViewControllerLogin: UIViewController {

    @IBOutlet weak var textFieldLogin: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    @IBAction func btnLogin(_ sender: UIButton) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Login"
        
        
        // summary: we used rx text observable properties to take the input from user then we combined them with the aid of the combineLatest operator into an observable sequence and when we received tap event from the user, we just passed the latest event emitted by the combine observable sequence to the login method

        // check textfield is empty using rxswift
        let observable1 = self.textFieldLogin.rx.text.orEmpty
        let observable2 = self.textFieldPassword.rx.text.orEmpty
        
        // blend observable1 and observable2 directly into the combineLatest sequence
        // we need to combine this two observables using combineLatest operator
        // combineLatest operator: it combines the latest events emitted by the two observable sequences (read rxmarbles website)
        let observableCombined = Observable.combineLatest(observable1, observable2)
        // now when the user taps the login button, we will use our observable combined and send the emitted result to the login method, to do that we use tap event from the rx exrension
        self.btnLogin.rx.tap
        // we apply with latest from operator then we pass through it combined observable
            .withLatestFrom(observableCombined)
        
        // finally we will subscribe to this observable sequence and implement onNext closure
            .subscribe(onNext: {
                
                // this is more concise way of writing code
                // $0 and $1 is default arguments we received in the closure
                // $0 is textFieldLogin value (username) and $1 is textFieldPassword value (password)
                self.login(user: $0, pass: $1)
            })
            .disposed(by: disposeBag)

        
        

    }

    
    func login(user: String, pass: String) {
        
        // validation logic
        
        //credentials are valid if the user enters email address for username field
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        let emailValid: Bool = emailTest.evaluate(with: user)
        
        // password must have at least 6 characters
        let passValid: Bool = (pass != "" && pass.count >= 6)
        
        if emailValid && passValid {
            let viewControllerFoodList = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerReactiveFoodTableView") as! ViewControllerReactiveFoodTableView
            self.navigationController?.pushViewController(viewControllerFoodList, animated: true)
        } else {
            
            displayAlert(title: "Wrong Credentials", message: "Please enter a valid username or password", vc: self)
            
        }
    }
    
    
    
    
}
