//
//  GXLineLayout.m
//  GXLCodeRepository
//
//  Created by JasonBourne on 2018/12/25.
//  Copyright © 2018 JasonBourne. All rights reserved.
//

#import "GXLineLayout.h"

@implementation GXLineLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/** 
 作用: 在这个方法中, 可以做一些初始化的操作. 在init中, 可能self.collectionView没有初始化
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat inset = (self.collectionView.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    // 计算collectView中心点o/[[['差值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attr in arr) {
        CGFloat detal = ABS(attr.center.x - centerX);
        
        // 根据间距值来, 计算缩放比例
        CGFloat scale = 1 - detal / self.collectionView.width * 0.4;
//        NSLog(@"%f", scale);
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arr;
}
/** 
 作用 : 停止滚动时候, 最终的偏移量  (proposeContentOffset: 不去干预它, 原本的便宜量)
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSLog(@"targetContentOffsetForProposedContentOffset");
    
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.size;
    
    // 通过父类得到这个矩形框中的item的属性
    NSArray *attrArr = [super layoutAttributesForElementsInRect:rect];
    
    // 当前的中心点
    CGFloat centerX = proposedContentOffset.x + self.collectionView.width * 0.5;
    
    CGFloat minSpace = CGFLOAT_MAX;
    for (UICollectionViewLayoutAttributes *attr in attrArr) {
        if (ABS(minSpace) > ABS(attr.center.x - centerX)) {
            minSpace = attr.center.x - centerX;
        }
        // 如果, minSpace等于负数, 说明在中心线的左侧, contentoffset 减小
    }
    
    proposedContentOffset.x += minSpace;
    return proposedContentOffset;
}
@end
