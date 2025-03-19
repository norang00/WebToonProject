//
//  RecommendViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import RxSwift
import RxCocoa

final class RecommendViewController: BaseViewController {

    private let recommendView = RecommendView()
    
    override func loadView() {
        view = recommendView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let images = [
            UIImage(named: "Image001")!,
            UIImage(named: "Image002")!,
            UIImage(named: "Image003")!,
            UIImage(named: "Image004")!,
            UIImage(named: "Image005")!
        ]
        recommendView.bannerView.setImages(images)
        
        self.navigationController?.navigationItem.title = Resources.Keys.TabTitle.tab_0.rawValue.localized

        
        
    }

}
