//
//  FavoriteTableViewCell.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 31/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    
    // Mark: Outlets
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var companyLogo: UIImageView!
    
    // Source of Truth
    var generalProduct: GeneralProduct? {
        didSet {
            updateViews()
        }
    }


    var pImage: UIImage? {
        didSet {
            updateViews()
        }
    }
        
    
    func updateViews() {
        guard let generalProduct = generalProduct else {return}
        DispatchQueue.main.async {
            self.productName.text = generalProduct.name
            guard let price = generalProduct.salePrice else {return}
            self.moneyLabel.text = "$\(price)"
            self.ratingImage.image = generalProduct.ratingImage
            self.companyLogo.image = generalProduct.companyImage
            self.buyButton.layer.cornerRadius = 8
            guard let productImage = self.pImage else {return}
            self.productImage.image = productImage
        }
        
    }

    // Mark: Actions
    @IBAction func buyButtonTapped(_ sender: Any) {
        guard let productUrl = generalProduct?.addToCartURL else {return}
        UIApplication.shared.open(URL(string: productUrl)! as URL, options: [:], completionHandler: nil)
    }
}
