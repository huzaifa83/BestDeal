//
//  CameraViewController.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 27/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit
import CloudSight

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CloudSightQueryDelegate  {
    
    // Mark: Outlets
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    var cloudsightQuery: CloudSightQuery!
    var cameraGeneralProducts = [GeneralProduct]()
    var generalProduct: GeneralProduct?
    var productImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.resultLabel.layer.borderColor = UIColor.black.cgColor
        self.resultLabel.layer.borderWidth = 1
        self.resultLabel.layer.cornerRadius = 4
        self.resultLabel.clipsToBounds = true
        //view.prefetchDataSource = self
        CloudSightConnection.sharedInstance().consumerKey = Constants.cloudSightKey
        CloudSightConnection.sharedInstance().consumerSecret = Constants.cloudSightSecret
        detailButton.isEnabled = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        cameraView.layer.borderColor = UIColor.gray.cgColor
        cameraView.layer.borderWidth = 2
        cameraView.layer.cornerRadius = 4
        detailButton.layer.cornerRadius = 8
        setUpNavbarHeight()
        // setupNavigationBarItems()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        // Check to see if the Camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            
            // Show the UIImagePickerController view
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Cannot access the camera");
        }
    }
    
    @IBAction func detailButtonPressed(_ sender: Any) {
        guard let searchTerm = resultLabel.text else { return }
        self.resultLabel.text = searchTerm
        ProductFacade.init().fetchProducts(productName: searchTerm) { (generalProducts) in
            guard let generalProducts = generalProducts else {
                return }
            self.cameraGeneralProducts = generalProducts
            DispatchQueue.main.async {
                // Little spinny guy off
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.productImage = self.imageView.image
                if let firstTab = self.tabBarController?.viewControllers![1] as? CameraResultsViewController {
                    firstTab.generalProducts = self.cameraGeneralProducts
                    firstTab.productImage = self.imageView.image
                    firstTab.productName = self.resultLabel.text
                    self.tabBarController?.selectedIndex = 1
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Dismiss the UIImagePickerController
        self.dismiss(animated: true, completion: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Assign the image reference to the image view to display
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        // Create JPG image data from UIImage
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        
        cloudsightQuery = CloudSightQuery(image: imageData,
                                          atLocation: CGPoint.zero,
                                          withDelegate: self,
                                          atPlacemark: nil,
                                          withDeviceId: "device-id")
        cloudsightQuery.start()
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        self.resultLabel.text = ""
        self.resultLabel.textColor = UIColor.lightGray
        self.resultLabel.backgroundColor = UIColor(red: 231/255, green: 232/255, blue: 227/255, alpha: 1)
        if self.detailButton.isEnabled == true {
            self.detailButton.isEnabled = false
            self.detailButton.backgroundColor = UIColor(red: 231/255, green: 232/255, blue: 227/255, alpha: 1)
            self.detailButton.setTitleColor(UIColor.lightText, for: .normal)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func cloudSightQueryDidFinishUploading(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishUploading")
        DispatchQueue.main.async {
            self.resultLabel.text = " Please wait for result..."
        }
    }
    
    func cloudSightQueryDidFinishIdentifying(_ query: CloudSightQuery!) {
        print("cloudSightQueryDidFinishIdentifying")
        
        // CloudSight runs in a background thread, and since we're only
        // allowed to update UI in the main thread, let's make sure it does.
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.resultLabel.text = query.name()
            self.detailButton.isEnabled = true
            self.resultLabel.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
            self.resultLabel.textColor = UIColor.white
            if self.detailButton.isEnabled == true {
                self.detailButton.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
                self.detailButton.setTitleColor(UIColor.white, for: .normal)
            }
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
        }
    }
    
    func cloudSightQueryDidFail(_ query: CloudSightQuery!, withError error: Error!) {
        print("CloudSight Failure: \(error)")
    }
    
    //     MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCameraResults" {
            if let firstTab = self.tabBarController?.viewControllers![1] as? CameraResultsViewController {
                firstTab.generalProducts = cameraGeneralProducts
                self.tabBarController?.selectedIndex = 1
            }
            guard let destinationVC = segue.destination as? CameraResultsViewController else {return}
            destinationVC.searchTerm = resultLabel.text
            destinationVC.generalProducts = self.cameraGeneralProducts
            destinationVC.productName = self.resultLabel.text
            destinationVC.productImage = self.imageView.image
        }
    }
    
    func setUpNavbarHeight() {
        for subview in (self.navigationController?.navigationBar.subviews)! {
            if NSStringFromClass(subview.classForCoder).contains("BarBackground") {
                var subViewFrame: CGRect = subview.frame
                let subView = UIView()
                // subViewFrame.origin.y = -20;
                subViewFrame.size.height = 70
                subView.frame = subViewFrame
                let logo = UIImage(named: "PriceShark")
                var imageView = UIImageView()
                imageView = UIImageView(image: logo)
                imageView.contentMode = .scaleAspectFill
                //                self.navigationItem.titleView = imageView
                subView.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.topAnchor.constraint(equalTo: subView.topAnchor, constant: 27).isActive = true
                imageView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -15).isActive = true
                imageView.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 1).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: -27).isActive = true
                subview.backgroundColor = .clear
                subView.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
                navigationController?.navigationBar.addSubview(subView)
                navigationController?.navigationBar.bottomAnchor.constraint(equalTo: subView.bottomAnchor).isActive = true
            }
        }
    }
}
