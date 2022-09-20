
//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//

import UIKit
import RxSwift
import RxCocoa

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

class ViewControllerTipCalculator: UIViewController {
    
    @IBOutlet weak var textFieldNumber: UITextField!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelTip: UILabel!
    @IBOutlet weak var labelPercent: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    fileprivate let disposeBag = DisposeBag()
    
    let doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "Done"
        item.style = UIBarButtonItem.Style.done
        return item
    }()
    
    var principal = 0.0
    
    
    func setupToolbar() {
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [doneButton]
        numberToolbar.sizeToFit()
        
        textFieldNumber.inputAccessoryView = numberToolbar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // done button in UIToolbar
        doneButton.rx.tap.subscribe({
            [weak self] _ in
            guard let this = self else {
                return
            }
            guard let numberTextLable = this.textFieldNumber.text else {
                return
            }
            guard !numberTextLable.isEmpty else {
                return
            }
            guard let number = Double(numberTextLable)?.roundToPlaces(2) else {
                return
            }
            print("number", number)
            this.principal = number
            // %.2f: float with to decimal number: eg 2.00
            this.textFieldNumber.text = "$\(String(format: "%.2f", this.principal))"
            this.calculator()
            this.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        
        slider.rx.value.subscribe({
            [weak self] _ in
            guard let this = self else {
                return
            }
            this.calculator()
        }).disposed(by: disposeBag)
        
        
        textFieldNumber.rx.controlEvent(.touchDown).subscribe({
            [weak self] _ in
            guard let this = self else {
                return
            }
            // clears text field text when user tapped
            this.textFieldNumber.text = ""
        }).disposed(by: disposeBag)

        setupToolbar()
    }
    
    
    
    func calculator() {
        print("calculator ran")
        let percent = Double(slider.value).roundToPlaces(2)
        
        print("slider.value", slider.value)
        print("percent", percent)
        
        // %.0f: float with to decimal number: eg 2
        labelPercent.text = "(\(String(format: "%.0f", percent * 100))%)"
        labelTip.text = "$\(String(format: "%.2f",principal * percent))"
        guard let number = Double(String(format: "%.2f",principal * percent)) else {
            return
        }
        labelTotal.text = "$\(principal + number)"
    }
    
}


