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
    
    func performNetworkActionWithConfirmationIfNeeded(_ action: @escaping () -> Void) {
        let isWiFi = NetworkStatusManager.shared.isUsingWiFi
        let isCellular = NetworkStatusManager.shared.isUsingCellular
        
        if isWiFi {
            action()
        } else if isCellular {
            showCellularAlert(
                title: AlertType.cellularWarning.title,
                message: AlertType.cellularWarning.message,
                confirmTitle: Resources.Keys.confirm.localized,
                cancelTitle: Resources.Keys.cancel.localized,
                confirmAction: {
                    action()
                },
                cancelAction: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            )
        } else {
            showAlert(title: CustomError.noInternet.title,
                      message: CustomError.noInternet.message)
        }
    }
    
    func showCellularAlert(title: String,
                           message: String,
                           confirmTitle: String,
                           cancelTitle: String,
                           confirmAction: @escaping () -> Void,
                           cancelAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmAction()
        }
        
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
