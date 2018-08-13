//
//  RoundedImage.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 5/8/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit


extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
