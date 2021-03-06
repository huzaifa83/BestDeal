//
//  CameraResultsViewController.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 3/8/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit

class CameraResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Mark: Outlets
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cameraImage: UIImageView!
    
    
    let productFacade = ProductFacade()
    var productImage: UIImage?
    var productName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBarItems()
        self.resultLabel.layer.borderColor = UIColor.black.cgColor
        self.resultLabel.layer.borderWidth = 1
        self.resultLabel.layer.cornerRadius = 4
        self.resultLabel.clipsToBounds = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    var generalProduct: GeneralProduct?
    var ebayProducts = [EbayItem]()
    var searchTerm: String?
    var generalProducts = [GeneralProduct]()
    //        didSet {
    //            DispatchQueue.main.async {
    //              //  self.tableView.reloadData()
    //            }
    //        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
        updateOnLoad()
        self.tabBarController?.tabBar.isHidden = false
    }
    func reloadTableView() {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if generalProducts.count > 0 {
            prepareMessage(message: "")
            return generalProducts.count
        }
        else {
            handleEmptyTableView()
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ResultsTableViewCell {
            let product =  generalProducts[indexPath.row]
            cell.delegate = self
            cell.layer.borderColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1).cgColor
            cell.layer.borderWidth = 1.5
            cell.layer.cornerRadius = 6
            cell.clipsToBounds = true
            cell.generalProduct = product
            guard let path =  product.mediumImage else {return UITableViewCell()}
            ProductFacade.init().fetchImage(generalProducts: path) { (image) in
                DispatchQueue.main.async {
                    cell.productImage.image = image
                }
            }
            return cell
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            // Delete the row from the data source
    //            generalProducts.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
    
    func updateOnLoad() {
        self.cameraImage.image = productImage
        self.resultLabel.text = productName
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFav" {
            if let firstTab = self.tabBarController?.viewControllers![3] as? FavoriteTableViewController {
                firstTab.generalProducts = generalProducts
                self.tabBarController?.selectedIndex = 3
            }
            guard let destinationVC = segue.destination as? FavoriteTableViewController else {return}
            if let selectedCell = sender as? ResultsTableViewCell {
                guard let indexPath = tableView.indexPath(for: selectedCell) else { return }
                var generalProductCoppy = self.generalProduct
                generalProduct = generalProducts[indexPath.row]
                destinationVC.generalProducts = generalProducts
                destinationVC.generalProduct = generalProductCoppy
            }
        }
    }
    
    func setupNavigationBarItems() {
        navBar.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        let height: CGFloat = 0 //whatever height you want to add to the existing height
        let bounds = self.navBar.bounds
        self.navBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        let size = CGSize(width: 20, height: 60)
        navBar.barTintColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        navBar.sizeThatFits(size)
        let logo = UIImage(named: "PriceShark")
        navBar.backItem?.titleView = UIImageView(image: logo)
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navItem.titleView = imageView
    }
}

extension CameraResultsViewController: ResultsTableViewCellDelegate {
    func cellButtonTapped(_ cell: ResultsTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let product = generalProducts[indexPath.row]
            
            if ProductFacade.favoriteProducts.contains(product){
                guard let index = ProductFacade.favoriteProducts.index(of: product) else {return}
                ProductFacade.favoriteProducts.remove(at: index)
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "FavInactive"), for: .normal)
            } else {
                ProductFacade.favoriteProducts.append(product)
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "FavActive"), for: .normal)
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { (_) in
                    self.performSegue(withIdentifier: "goToFav", sender: cell)
                }
                
                //            let returnedProduct = ProductFacade.isFavoriteProduct(generalProduct: product)
                //            print(returnedProduct?.isFavorites.count ?? 0)
                //            self.generalProduct = returnedProduct
                //            guard let upc = product.upc else { return }
                //            product.isFavorites.contains(upc) ? cell.favoriteButton.setImage(#imageLiteral(resourceName: "FavActive"), for: .normal) : cell.favoriteButton.setImage(#imageLiteral(resourceName: "FavActive"), for: .normal)
                //            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { (_) in
                //                self.performSegue(withIdentifier: "goToFav", sender: cell)
                //            }
                
            }
        }
    }
}


//extension CameraResultsViewController: UITableViewDataSourcePrefetching {
//
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//        for indexPath in indexPaths {
//            let product = self.generalProducts[indexPath.row]
//            print("THIS IS THE PRODUCT \(product.name)")
//            guard let productImage = product.mediumImage,
//            let url = URL(string: productImage) else { return }
//            URLSession.shared.dataTask(with: url)
//        }
//    }
//}

// MARK: UITableView Empty State Helper Methods
extension CameraResultsViewController {
    
    func handleEmptyTableView() {
        prepareMessage(message: "Hurry up and search for a product in the Camera View! 📷")
    }
    
    func handleNoResults() {
        DispatchQueue.main.async {
            self.generalProducts.removeAll()
            self.tableView.reloadData()
            //self.movieSearchBar.text = ""
        }
        prepareMessage(message: "No results found. \n\nPlease stop looking for adult films.")
    }
    
    func prepareMessage(message: String) {
        let rect = CGRect(origin: CGPoint(x: 100,y :-200), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = .none;
    }
}



