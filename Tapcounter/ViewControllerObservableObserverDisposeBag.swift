import UIKit
import RxSwift
import RxCocoa

class ViewControllerObservableObserverDisposeBag: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.becomeFirstResponder()
        
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = UISwipeGestureRecognizer.Direction.down
        
        _ = gesture.rx.event.subscribe({
            [weak self] _ in
            guard let this = self else {
                return
            }
            this.view.endEditing(true)
        })
        
        view.addGestureRecognizer(gesture)
    }
    
}
