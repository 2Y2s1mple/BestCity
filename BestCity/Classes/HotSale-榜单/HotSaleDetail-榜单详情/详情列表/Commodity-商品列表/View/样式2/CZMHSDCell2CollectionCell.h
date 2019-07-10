//
//  CZMHSDCell2CollectionCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/7/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZMHSDCell2CollectionCell : UICollectionViewCell
@property (nonatomic, strong) NSDictionary *dataDic;
/** 位置 */
@property (nonatomic, assign) NSInteger indexNumber;
@end

NS_ASSUME_NONNULL_END
