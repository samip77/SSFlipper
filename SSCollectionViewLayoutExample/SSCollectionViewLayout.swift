//
//  SSCollectionViewLayout.swift
//  SSCollectionViewLayoutExample
//
//  Created by Samip on 9/22/16.
//  Copyright © 2016 Samip. All rights reserved.
//

import UIKit

class SSCollectionViewLayout: UICollectionViewLayout {
    
    override init() {
        super.init()
        collectionView?.pagingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var minAlpha:CGFloat = 0
    private var maxAlpha:CGFloat = 1
    
    //offset between visible and non visible cell size
    var widthOffset:CGFloat = 40
    var heightOffset:CGFloat = 40
    
    
    var cellInset:UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    //    UIEdgeInsetsZero{
    //        didSet{
    //            print(cellInset)
    //        }
    //    }
    //
    
    private var cellSize:CGSize {
        if let size = collectionView?.bounds.size{
            return size
        }
        return  CGSizeZero
    }
    
    private var sectionCount:Int{
        if let sectionCount  = collectionView?.numberOfSections(){
            return sectionCount
        }
        return 0
    }
    
    private func numberOfItem(inSection:Int) -> Int {
        if let count = collectionView?.numberOfItemsInSection(inSection){
            return count
        }
        return 0
    }
    
    private var currentItemIndex:Int{
        return max(0, Int(contentOffset.y / cellSize.height))
    }
    
    private var nextItemBecomeCurrentPercentage:CGFloat{
        return (contentOffset.y / cellSize.height) - CGFloat(currentItemIndex)
    }
    
    private var contentOffset:CGPoint{
        if let offset = collectionView?.contentOffset{
            return offset
        }
        return CGPointZero
    }
    
    private var centerPostion:CGPoint{
        if let collectionView = collectionView{
            let xposition = collectionView.center.x - collectionView.frame.origin.x  + cellInset.left/2 - cellInset.right/2
            let yPosition = collectionView.center.y - collectionView.frame.origin.y + cellInset.top/2 - cellInset.bottom/2
            let center = CGPoint(x: xposition, y:yPosition )
            return center
        }
        return CGPointZero
    }
    
    private var cache = [[UICollectionViewLayoutAttributes]]()
    private var itemCount:Int = 0
    
    //MARK:- Layout Methods
   
    //Calculations for attributes
    override func prepareLayout() {
        cache.removeAll(keepCapacity: false)
        var yOffset:CGFloat = 0
        itemCount = 0
        
        for sectionIndex in 0 ..< sectionCount{
            var  sectionCache =  [UICollectionViewLayoutAttributes]()
            
            for itemIndex in 0 ..< numberOfItem(sectionIndex){
                
                let indexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
                let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attribute.zIndex = -itemCount
                
                if itemCount == currentItemIndex+1{
                    
                    attribute.alpha = minAlpha + max((maxAlpha-minAlpha) * nextItemBecomeCurrentPercentage, 0)
                    let width = cellSize.width - cellInset.left - cellInset.right - widthOffset + (widthOffset * nextItemBecomeCurrentPercentage)
                    let height = cellSize.height - cellInset.top - cellInset.bottom - heightOffset + (heightOffset * nextItemBecomeCurrentPercentage)
                    
                    let deltaWidth = width/cellSize.width
                    let deltaHeight = height/cellSize.height
                    
                    attribute.frame = CGRectMake(0, yOffset, cellSize.width, cellSize.height)
                    attribute.transform = CGAffineTransformMakeScale(deltaWidth, deltaHeight)
                    attribute.center.y = centerPostion.y + contentOffset.y
                    attribute.center.x = centerPostion.x + contentOffset.x
                    yOffset += cellSize.height
                    
                }else{
                    
                    attribute.frame = CGRectMake(0, yOffset, cellSize.width - cellInset.left - cellInset.right, cellSize.height - cellInset.top - cellInset.bottom)
                    attribute.center.y = centerPostion.y + yOffset
                    attribute.center.x = centerPostion.x
                    yOffset += cellSize.height
                    
                }
                
                sectionCache.append(attribute)
                itemCount += 1
                
            }
            
            cache.append(sectionCache)
            
        }
    }
    
    //Return the size of ContentView
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: cellSize.width, height: CGFloat(itemCount)*cellSize.height)
    }
    
    //Return Attributes  whose frame lies in the Visible Rect
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for sectionAttributes in cache{
            for attribute in sectionAttributes{
                
                if CGRectIntersectsRect(attribute.frame, rect){
                    layoutAttributes.append(attribute)
                }
                
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = cache[indexPath.section][indexPath.row]
        return attribute
    }
    
    
    //Recalculate the attributes if bounds change.. i.e if scrolled
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    //For snapping Effect
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let itemIndex = round(proposedContentOffset.y / cellSize.height)
        let yOffset = itemIndex * cellSize.height
        return CGPoint(x: 0, y: yOffset)
    }
    
}
