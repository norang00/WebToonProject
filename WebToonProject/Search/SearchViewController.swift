//
//  SearchViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.search.rawValue.localized

        bind()
    }
    
    private func bind() {
        
    }

}
