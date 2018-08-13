//
//  ExtensionHelper.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 27/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit

extension UISearchBar {
    func removeBackgroundImageView(){
        if let view:UIView = self.subviews.first {
            for curr in view.subviews {
                guard let searchBarBackgroundClass = NSClassFromString("UISearchBarBackground") else {
                    return
                }
                if curr.isKind(of:searchBarBackgroundClass){
                    if let imageView = curr as? UIImageView{
                        imageView.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
}

extension UINavigationBar {
    
    static func sizeThatFits(_ size: CGSize) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: 100.0)
    }
    
}
