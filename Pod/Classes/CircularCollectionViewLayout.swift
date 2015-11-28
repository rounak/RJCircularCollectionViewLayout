//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 27/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

public class BaseCircularCollectionViewCell: UICollectionViewCell {
    override public func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5)*CGRectGetHeight(self.bounds)
    }
}

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle*1000000)
            transform = CGAffineTransformMakeRotation(angle)
        }
    }
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copyWithZone(zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object {
            if (!object.isKindOfClass(CircularCollectionViewLayoutAttributes.self)) {
                return false
            }
            let objectCast = object as! CircularCollectionViewLayoutAttributes
            if objectCast.angle != self.angle || objectCast.anchorPoint != self.anchorPoint {
                return false
            }
            return super.isEqual(object)
        } else {
            return false
        }
    }
    
    override var hash: Int {
        return super.hash ^ self.anchorPoint.x.hashValue ^ self.anchorPoint.y.hashValue ^ self.angle.hashValue
    }
    
}

public class CircularCollectionViewLayout: UICollectionViewLayout {
    
    @IBInspectable var itemSize: CGSize = CGSize(width: 150, height: 150) {
        didSet {
            anglePerItem = atan(itemSize.width/radius)
            attributesList = []
            invalidateLayout()
        }
    }
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItemsInSection(0) > 0 ? -CGFloat(collectionView!.numberOfItemsInSection(0)-1)*anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme*collectionView!.contentOffset.x/(collectionViewContentSize().width - CGRectGetWidth(collectionView!.bounds))
    }
    
    @IBInspectable var radius: CGFloat = 500 {
        didSet {
            anglePerItem = atan(itemSize.width/radius)
            attributesList = []
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat = 0
    
    var attributesList: [CircularCollectionViewLayoutAttributes] = []
    
    override public func collectionViewContentSize() -> CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItemsInSection(0))*itemSize.width,
            height: CGRectGetHeight(collectionView!.bounds))
    }
    
    override public class func layoutAttributesClass() -> AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override public func prepareLayout() {
        super.prepareLayout()
        let totalItems = collectionView!.numberOfItemsInSection(0) - 1
        if attributesList.count != totalItems {
            let anchorPointY = ((itemSize.height/2.0) + radius)/itemSize.height
            attributesList = (0...totalItems).map { (i) -> CircularCollectionViewLayoutAttributes in
                let attributes = CircularCollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
                attributes.size = self.itemSize
                attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
                return attributes
            }
        }
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let centerX = collectionView!.contentOffset.x + (CGRectGetWidth(collectionView!.bounds)/2.0)
        let theta = atan2(CGRectGetWidth(collectionView!.bounds)/2.0, radius + (itemSize.height/2.0) - (CGRectGetHeight(collectionView!.bounds)/2.0))

        var startIndex = 0
        var endIndex = collectionView!.numberOfItemsInSection(0) - 1
        
        if (angle < -theta) {
            startIndex = Int(floor((-theta - angle)/anglePerItem))
        }
        
        endIndex = min(endIndex, Int(ceil((theta - angle)/anglePerItem)))
        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        
        let centerY = CGRectGetMidY(collectionView!.bounds)
        
        for var i = startIndex; i <= endIndex; i++ {
            let attributes = attributesList[i]
            attributes.center = CGPoint(x: centerX, y: centerY)
            attributes.angle = self.angle + (anglePerItem*CGFloat(i))
        }
        return Array(attributesList[startIndex...endIndex])
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
        -> UICollectionViewLayoutAttributes {
            return attributesList[indexPath.row]
    }
    
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize().width - CGRectGetWidth(collectionView!.bounds))
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
            multiplier = ceil(ratio)
        } else if (velocity.x < 0) {
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
    }
    
}
