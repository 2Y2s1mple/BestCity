//
//  CZEACCollectionCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/8/8.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
//数据模型
#import "CZEAttentionItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZEACCollectionCell : UICollectionViewCell
/** 数据 */
@property (nonatomic, strong) CZEAttentionUserModel *model;
@end

NS_ASSUME_NONNULL_END
