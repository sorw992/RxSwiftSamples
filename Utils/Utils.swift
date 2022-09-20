
import Foundation
import UIKit


func displayAlert(title: String, message: String, vc: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
    
}

func push(identifier: String, self: UIViewController) {
    if let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
