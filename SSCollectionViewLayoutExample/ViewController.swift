//
//  ViewController.swift
//  SSCollectionViewLayoutExample
//
//  Created by Samip on 9/22/16.
//  Copyright © 2016 Samip. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.collectionViewLayout = SSCollectionViewLayout()
            
    }
 
    
 
    
 

}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 10
        cell.titleLabel.text = "\(indexPath.row)"
        if indexPath.row % 2 == 0{
        cell.backgroundColor = UIColor.redColor()
        }
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let index = NSIndexPath(forItem: 2, inSection: 0)
        collectionView.scrollsToTop = true

        //collectionView.scrollToItemAtIndexPath(index, atScrollPosition: .Bottom, animated: true)
    }
}