//
//  FavoriteTableViewController.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 31/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    // Mark: Outlets
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    var generalProduct: GeneralProduct?
    var generalProducts: [GeneralProduct] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupNavigationBarItems() {
        navBar.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        let height: CGFloat = 6 //whatever height you want to add to the existing height
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Table view data source
    
    
    func emptyDude() {
        print("You haven't searched for a product in the Search Bar or Camera. \n\nHurry up and choose your Favorite.")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ProductFacade.favoriteProducts.count > 0 {
            prepareMessage(message: "")
            return ProductFacade.favoriteProducts.count
        }
        else {
            handleEmptyTableView()
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        let product = ProductFacade.favoriteProducts[indexPath.row]
        cell.backgroundColor = UIColor.white
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
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ProductFacade.favoriteProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

// MARK: UITableView Empty State Helper Methods
extension FavoriteTableViewController {
    
    func handleEmptyTableView() {
        prepareMessage(message: "Hurry up and choose your Favorite! ⭐️")
    }
    
    func handleNoResults() {
        DispatchQueue.main.async {
            ProductFacade.favoriteProducts.removeAll()
            //self.tableView.reloadData()
        }
        prepareMessage(message: "You haven't searched for a product in the Search Bar or Camera. \n\nHurry up and choose your Favorite.")
    }
    
    func prepareMessage(message: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        //let messageLabel = UILabel()
        
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





