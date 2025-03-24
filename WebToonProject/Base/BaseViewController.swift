//
//  BaseViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import Network
import RxSwift
import RxCocoa
import Toast

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: Resources.Keys.confirm.localized, style: .default)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
    
}
