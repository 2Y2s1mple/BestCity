//
//  CZFestivalCollectOneCell.h
//  BestCity
//
//  Created by JasonBourne on 2019/12/13.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZMainViewSubOneVCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZFestivalCollectOneCell : UICollectionViewCell
/** 新人专区 */
@property (nonatomic, strong) NSArray *allowanceGoodsList;
/** 是否是新人 */
@property (nonatomic, assign) BOOL newUser;
/** 跑马灯 */
@property (nonatomic, strong) NSArray *messageList;

/** 总数据 */
@property (nonatomic, strong) CZMainViewSubOneVCModel *model;


@end

NS_ASSUME_NONNULL_END
