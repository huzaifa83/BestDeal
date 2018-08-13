//
//  HomeViewController.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 27/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchTerm: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        cameraButton.layer.cornerRadius = 20
        cameraButton.clipsToBounds = true
        cameraButton.layer.borderColor = UIColor.white.cgColor
        searchBar.backgroundImage = nil
        searchBar.delegate = self
        searchBar.removeBackgroundImageView()
        searchBar.layer.cornerRadius = searchBar.bounds.height / 2
        searchBar.clipsToBounds = true
        searchBar.layer.shadowColor = UIColor.darkGray.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 1, height: 1)
        searchBar.layer.shadowRadius = 2
        self.tabBarController?.tabBar.isHidden = true
        searchBar.layer.shadowOpacity = 0.65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //Source of Truth
    var generalProducts = [GeneralProduct]()
    var generalProduct: GeneralProduct?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // Little spinny guy on
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        self.searchTerm = searchTerm
        
        let productFacade = ProductFacade()
        productFacade.fetchProducts(productName: searchTerm) { (generalProducts) in
            guard let results = generalProducts else { return print("something went wrong")}
            self.generalProducts = results
            
            if let secondTab = self.tabBarController?.viewControllers![2] as? FullResultsTableViewController {
                secondTab.generalProducts = results
                self.tabBarController?.selectedIndex = 2
            }
            // Little spinny guy off
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
