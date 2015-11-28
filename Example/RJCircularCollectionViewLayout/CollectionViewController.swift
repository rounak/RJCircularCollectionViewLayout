//
//  CollectionViewController.swift
//  RJCircularCollectionViewLayout
//
//  Created by Rounak Jain on 11/26/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    let images: [String] = NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: "Images")
    
    var dataSource: [String] = []
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.registerNib(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        gradientLayer.colors = [UIColor(red:0.1107, green:0.7848, blue:0.7686, alpha:1.0).CGColor,
            UIColor(red:0.0739, green:0.0848, blue:0.4347, alpha:1.0).CGColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageViewCell
        cell.imageView.image = UIImage(named: self.images[indexPath.item])!
        return cell
    }

}
